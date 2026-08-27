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
	
	try({
		hisse_result_try_2 <- hisse::hisse(
			phy = phy,
			data = traits_binary,
			trans.rate = transition_matrix,
			turnover = turnover_vector,
			eps = eps_vector,
			hidden.states = TRUE,
			f = rep(sample_f, 2),
			tip.fog = c(1, 1),
			restart.obj = hisse_result,
			sann = FALSE
		)
		if(hisse_result_try_2$AICc < hisse_result$AICc) {
			hisse_result <- hisse_result_try_2
		}
	})
	
	
	
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

get_rarity_pairs <- function(rarity_type) {
	rarity_pairs <- list()
	n_types <- length(rarity_type)
	for (i in sequence(n_types)) {
		for (j in sequence(n_types)) {
			if (i<j) {
				rarity_pairs <- append(rarity_pairs, c(rarity_type[i], rarity_type[j]))
			}	
		}	
	}
	return(rarity_pairs)
}

# hisse::MuHiSSE(phy = data$phy, data = gr_gl_data, trans.rate = trans.rate_ard_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)

do_single_muhisse_run_biivariate <- function(
	rarity_pair,
	div_model_type,
	trans_model_type,
	n_hidden_states_muhisse,
	sample_f,
	traits,
	phy
) {
	traits_two <- convert_to_rarity_two_dimension(traits, rarity_pair[1], rarity_pair[2])

	n_hidden_states_transition <- n_hidden_states_muhisse

	if (grepl("CID", div_model_type)) {
		# we're going to run a CID model
		n_hidden_states_transition <- 2 * n_hidden_states_muhisse
	}

	transition_matrix <- hisse::TransMatMakerMuHiSSE(
		hidden.traits = n_hidden_states_transition - 1,
		make.null = FALSE
	)
	if (trans_model_type == "ER") {
		transition_matrix <- hisse::TransMatMakerMuHiSSE(
			hidden.traits = n_hidden_states_transition - 1,
			make.null = TRUE
		)
	}

	run_name <- paste0(
		"bivariate_div_",
		div_model_type,
		"_trans_",
		trans_model_type,
		"_hidden_",
		n_hidden_states_muhisse,
		"_raritytype1_",
		rarity_pair[1],
		"_raritytype2_",
		rarity_pair[2]
	)

	turnover_vector <- sequence(4 * n_hidden_states_muhisse) # since binary trait
	eps_vector <- sequence(4 * n_hidden_states_muhisse)

	if (grepl("CID", div_model_type)) {
		# we're going to run a CID model
		turnover_vector <- rep(seq_len(4 * n_hidden_states_muhisse), each = 2)
		eps_vector <- rep(seq_len(4 * n_hidden_states_muhisse), each = 2)
	}

	if (grepl("turnover_only", div_model_type)) {
		eps_vector <- rep(1, length(eps_vector))
	}

	save(list = ls(), file = paste0("debug/", run_name, ".rda"))

	muhisse_result <- hisse::MuHiSSE(
		phy = phy,
		data = traits_two,
		trans.rate = transition_matrix,
		turnover = turnover_vector,
		eps = eps_vector,
		hidden.states = TRUE,
		f = rep(sample_f, 4)
	)

	try({
		muhisse_result_try_2 <- hisse::MuHiSSE(
			phy = phy,
			data = traits_two,
			trans.rate = transition_matrix,
			turnover = turnover_vector,
			eps = eps_vector,
			hidden.states = TRUE,
			f = rep(sample_f, 4),
			restart.obj = muhisse_result,
			sann = FALSE
		)
		if (muhisse_result_try_2$AICc < muhisse_result$AICc) {
			muhisse_result <- muhisse_result_try_2
		}
	})

	muhisse_result$settings <- list(
		rarity_type1 = rarity_pair[1],
		rarity_type2 = rarity_pair[2],
		div_model_type = div_model_type,
		trans_model_type = trans_model_type,
		n_hidden_states = n_hidden_states_muhisse,
		run_name = run_name
	)

	save(muhisse_result, file = paste0("results/", run_name, ".rda"))
	return(muhisse_result)
}