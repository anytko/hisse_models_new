
get_data_tree_1011 <- function() {
    chrono_phylogeny <- read.tree("data/gdr_phy.newick")
    full_rarity_data <- read.csv("data/new_rarity.csv")
    full_rarity_data <- full_rarity_data %>% select(-X)

    return(list(trait=full_rarity_data, phy=chrono_phylogeny))
}


gr_rarity_1011 <- function(trait_data) {
  trait_data %>%
    mutate(rarity = ifelse(substr(GRLFRLPL, 1, 3) == "GR+", 1, 0)) %>%
    select(-GRLFRLPL)
}


gl_rarity_1011 <- function(trait_data) {
  trait_data %>%
    mutate(rarity = ifelse(substr(GRLFRLPL, 4, 6) == "GL+", 1, 0)) %>%
    select(-GRLFRLPL)
}

fr_rarity_1011 <- function(trait_data) {
  trait_data %>%
    mutate(rarity = ifelse(substr(GRLFRLPL, 7, 9) == "FR+", 1, 0)) %>%
    select(-GRLFRLPL)
}

fl_rarity_1011 <- function(trait_data) {
  trait_data %>%
    mutate(rarity = ifelse(substr(GRLFRLPL, 10, 12) == "FL+", 1, 0)) %>%
    select(-GRLFRLPL)
}

pl_rarity_1011 <- function(trait_data) {
  trait_data %>%
    mutate(rarity = ifelse(substr(GRLFRLPL, 13, 15) == "PL+", 1, 0)) %>%
    select(-GRLFRLPL)
}

gr_gl_rarity_1011 <- function(trait_data) {
  trait_data %>%
    mutate(
      gr_rarity = ifelse(substr(GRLFRLPL, 1, 3) == "GR+", 1, 0),
      gl_rarity = ifelse(substr(GRLFRLPL, 4, 6) == "GL+", 1, 0)
    ) %>%
    select(-GRLFRLPL)
}

gr_fr_rarity_1011 <- function(trait_data) {
  trait_data %>%
    mutate(
      gr_rarity = ifelse(substr(GRLFRLPL, 1, 3) == "GR+", 1, 0),
      fr_rarity = ifelse(substr(GRLFRLPL, 7, 9) == "FR+", 1, 0)
    ) %>%
    select(-GRLFRLPL)
}

gr_fl_rarity_1011 <- function(trait_data) {
  trait_data %>%
    mutate(
      gr_rarity = ifelse(substr(GRLFRLPL, 1, 3) == "GR+", 1, 0),
      fl_rarity = ifelse(substr(GRLFRLPL, 10, 12) == "FL+", 1, 0)
    ) %>%
    select(-GRLFRLPL)
}


gr_pl_rarity_1011 <- function(trait_data) {
  trait_data %>%
    mutate(
      gr_rarity = ifelse(substr(GRLFRLPL, 1, 3) == "GR+", 1, 0),
      pl_rarity = ifelse(substr(GRLFRLPL, 13, 15) == "PL+", 1, 0)
    ) %>%
    select(-GRLFRLPL)
}

gl_fr_rarity_1011 <- function(trait_data) {
  trait_data %>%
    mutate(
      gl_rarity = ifelse(substr(GRLFRLPL, 4, 6) == "GL+", 1, 0),
      fr_rarity = ifelse(substr(GRLFRLPL, 7, 9) == "FR+", 1, 0)
    ) %>%
    select(-GRLFRLPL)
}

gl_fl_rarity_1011 <- function(trait_data) {
  trait_data %>%
    mutate(
      gl_rarity = ifelse(substr(GRLFRLPL, 4, 6) == "GL+", 1, 0),
      fl_rarity = ifelse(substr(GRLFRLPL, 10, 12) == "FL+", 1, 0)
    ) %>%
    select(-GRLFRLPL)
}

gl_pl_rarity_1011 <- function(trait_data) {
  trait_data %>%
    mutate(
      gl_rarity = ifelse(substr(GRLFRLPL, 4, 6) == "GL+", 1, 0),
      pl_rarity = ifelse(substr(GRLFRLPL, 13, 15) == "PL+", 1, 0)
    ) %>%
    select(-GRLFRLPL)
}

fr_fl_rarity_1011 <- function(trait_data) {
  trait_data %>%
    mutate(
      fr_rarity = ifelse(substr(GRLFRLPL, 7, 9) == "FR+", 1, 0),
      fl_rarity = ifelse(substr(GRLFRLPL, 10, 12) == "FL+", 1, 0)
    ) %>%
    select(-GRLFRLPL)
}

fr_pl_rarity_1011 <- function(trait_data) {
  trait_data %>%
    mutate(
      fr_rarity = ifelse(substr(GRLFRLPL, 7, 9) == "FR+", 1, 0),
      pl_rarity = ifelse(substr(GRLFRLPL, 13, 15) == "PL+", 1, 0)
    ) %>%
    select(-GRLFRLPL)
}

fl_pl_rarity_1011 <- function(trait_data) {
  trait_data %>%
    mutate(
      fl_rarity = ifelse(substr(GRLFRLPL, 10, 12) == "FL+", 1, 0),
      pl_rarity = ifelse(substr(GRLFRLPL, 13, 15) == "PL+", 1, 0)
    ) %>%
    select(-GRLFRLPL)
}



summarize_results <- function(models) {
  # Extract AICc values from each model
  aic_values <- sapply(models, function(model) model$AICc)
  
  # Find the minimum AICc value (reference model)
  min_aic <- min(aic_values)
  
  # Calculate ΔAICc (difference from the minimum AICc)
  delta_aic <- aic_values - min_aic
  
  # Create a summary data frame
  aic_comparison <- data.frame(
    Model = names(aic_values),
    AICc = aic_values,
    Delta_AICc = delta_aic
  )
  
  return(aic_comparison)
}