convert_to_rarity_single_dimension <- function(trait_data, matching_rare="GR") {
	new_data <- trait_data |>
		mutate(
			rarity = ifelse(
				grepl(paste0(matching_rare, "+"), GRLFRLPL, fixed = TRUE),
				1,
				0
			)
		) |>
		select(-GRLFRLPL)
	return(new_data)
}

convert_to_rarity_two_dimension <- function(
	trait_data,
	matching_first = "GR",
	matching_second = "GL"
) {
	new_data_1 <- convert_to_rarity_single_dimension(trait_data, matching_first)
	colnames(new_data_1) <- gsub(
		"rarity",
		paste0(tolower(matching_first), "_rarity"),
		colnames(new_data_1)
	)
	
	new_data_2 <- convert_to_rarity_single_dimension(
		trait_data,
		matching_second
	)
	colnames(new_data_2) <- gsub(
		"rarity",
		paste0(tolower(matching_second), "_rarity"),
		colnames(new_data_2)
	)
	new_data <- dplyr::left_join(new_data_1, new_data_2, by="species")
	return(new_data)
}

do_single_hisse_run_univariate <- function(
	rarity_type,
	div_model_type,
	trans_model_type,
	n_hidden_states,
	sample_f,
	traits,
	phy
) {
	traits_binary <- convert_to_rarity_single_dimension(traits, rarity_type)
	
	n_hidden_states_transition <- n_hidden_states
	
	if (grepl("CID", div_model_type)) {
		# we're going to run a CID model
		n_hidden_states_transition <- 2 * n_hidden_states
	}

	transition_matrix <- hisse::TransMatMakerHiSSE(
		hidden.traits = n_hidden_states_transition - 1,
		make.null = FALSE
	)
	if (trans_model_type == "ER") {
		transition_matrix <- hisse::TransMatMakerHiSSE(
			hidden.traits = n_hidden_states_transition - 1,
			make.null = TRUE
		)
	}
	
	
	run_name <- paste0(
		"univariate_div_",
		div_model_type,
		"_trans_",
		trans_model_type,
		"_hidden_",
		n_hidden_states,
		"_raritytype_",
		rarity_type
	)
	
	turnover_vector <- sequence(2 * n_hidden_states) # since binary trait
	eps_vector <- sequence(2 * n_hidden_states)
	
	if(grepl("CID", div_model_type)) { # we're going to run a CID model
		turnover_vector <- rep(seq_len(2*n_hidden_states), each = 2)
		eps_vector <- rep(seq_len(2*n_hidden_states), each = 2)
	}
	
	if(grepl("turnover_only", div_model_type)) {
		eps_vector <- rep(1, length(eps_vector))
	}

	save(list=ls(), file=paste0("debug/", run_name, ".rda"))
	
	hisse_result <- hisse::hisse(
		phy = phy,
		data = traits_binary,
		trans.rate = transition_matrix,
		turnover = turnover_vector,
		eps = eps_vector,
		hidden.states = TRUE,
		f = rep(sample_f,2),
		tip.fog = c(1, 1)
	)
	
	hisse_result$settings <- list(
		rarity_type = rarity_type,
		div_model_type = div_model_type,
		trans_model_type = trans_model_type,
		n_hidden_states = n_hidden_states,
		run_name = run_name
	)
	
	save(hisse_result, file=paste0("results/", run_name, ".rda"))
	return(hisse_result)
}