library(targets)
library(tarchetypes)

ncores_to_allocate <- max(1, floor(0.7 * parallel::detectCores()))


tar_option_set(
	packages = c(
		"ggplot2",
		"corHMM",
		"geiger",
		"ape",
		"dplyr",
		"nloptr",
		"dentist",
		"phytools",
		"hisse"
	),
	controller = crew_controller_local(workers = ncores_to_allocate)
)

source("_functions.R")
source("_functions_additional.R")

list(
	tar_target(data_tree, get_data_tree_1011()),
	tar_target(rarity_type, c("GR", "GL", "FR", "FL", "PL")),
	tar_target(phy, data_tree$phy),
	tar_target(traits, data_tree$trait),
	tar_target(n_hidden_states, 4), # can change this to allow more hidden states
	tar_target(sample_f, 0.004044),
	tar_target(
		div_model_type,
		c("CID_full", "HISSE_full", "CID_turnover_only", "HISSE_turnover_only")
	),
	tar_target(trans_model_type, c("ARD", "ER")),
	tar_target(
		name = univariate_hisse_runs,
		command = do_single_hisse_run_univariate(
			rarity_type,
			div_model_type,
			trans_model_type,
			n_hidden_states,
			sample_f,
			traits,
			phy
		),
		pattern = cross(
			rarity_type,
			div_model_type,
			trans_model_type,
			n_hidden_states,
			sample_f,
			traits,
			phy
		)
	)
)
