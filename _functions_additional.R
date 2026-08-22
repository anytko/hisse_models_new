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

