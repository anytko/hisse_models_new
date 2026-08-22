library(targets)
library(tarchetypes)



tar_option_set(
         packages = c("ggplot2", "corHMM", "geiger", "ape", "dplyr", "nloptr", "dentist", "phytools", "hisse")
 )

source("_functions.R")
source("_functions_additional.R")

list(
	tar_target(data_tree, get_data_tree_1011()),
	tar_target(rarity_types, c("GR", "GL", "FR", "FL", "PL")),
	tar_target(phy, data_tree$phy),
	tar_target(traits, data_tree$trait),
	
	
	
	
	
    tar_target(data_1011, get_data_tree_1011()),
    tar_target(gr_data_1011, gr_rarity_1011(data_1011$trait)),
    tar_target(gl_data_1011, gl_rarity_1011(data_1011$trait)),
    tar_target(fr_data_1011, fr_rarity_1011(data_1011$trait)),
    tar_target(fl_data_1011, fl_rarity_1011(data_1011$trait)),
    tar_target(pl_data_1011, pl_rarity_1011(data_1011$trait)),
    tar_target(gr_gl_data_1011, gr_gl_rarity_1011(data_1011$trait)),
    tar_target(gr_fr_data_1011, gr_fr_rarity_1011(data_1011$trait)),
    tar_target(gr_fl_data_1011, gr_fl_rarity_1011(data_1011$trait)),
    tar_target(gr_pl_data_1011, gr_pl_rarity_1011(data_1011$trait)),
    tar_target(gl_fr_data_1011, gl_fr_rarity_1011(data_1011$trait)),
    tar_target(gl_fl_data_1011, gl_fl_rarity_1011(data_1011$trait)),
    tar_target(gl_pl_data_1011, gl_pl_rarity_1011(data_1011$trait)),
    tar_target(fr_fl_data_1011, fr_fl_rarity_1011(data_1011$trait)),
    tar_target(fr_pl_data_1011, fr_pl_rarity_1011(data_1011$trait)),
    tar_target(fl_pl_data_1011, fl_pl_rarity_1011(data_1011$trait)),

#### TRANSITION RATE MATRICIES

# CID one dimension ARD & Hisse ARD
    tar_target(trans.rate_ard, hisse::TransMatMakerHiSSE(hidden.traits=3, make.null=FALSE)),

# CID one dimension ER & Hisse ER
    tar_target(trans.rate_er, hisse::TransMatMakerHiSSE(hidden.traits=3, make.null=TRUE)),

# CID two dimension ARD & MuHisse ARD
    tar_target(trans.rate_ard_mu, hisse::TransMatMakerMuHiSSE(hidden.traits=3, make.null=FALSE)),

# CID two dimension ER & MuHisse ER
    tar_target(trans.rate_er_mu, hisse::TransMatMakerMuHiSSE(hidden.traits=3, make.null=TRUE)),


## MODELS 

# CID one dimension ARD

    tar_target(cid_fr_ard, hisse::hisse(phy = data_1011$phy, data = fr_data_1011, trans.rate = trans.rate_ard, turnover = c(1, 1, 2, 2, 3, 3, 4, 4), eps = c(1,1,2,2,3,3,4,4), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),

    tar_target(cid_fl_ard, hisse::hisse(phy = data_1011$phy, data = fl_data_1011, trans.rate = trans.rate_ard, turnover = c(1, 1, 2, 2, 3, 3, 4, 4), eps = c(1,1,2,2,3,3,4,4), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),

    tar_target(cid_gr_ard, hisse::hisse(phy = data_1011$phy, data = gr_data_1011, trans.rate = trans.rate_ard, turnover = c(1, 1, 2, 2, 3, 3, 4, 4), eps = c(1,1,2,2,3,3,4,4), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),
  
    tar_target(cid_gl_ard, hisse::hisse(phy = data_1011$phy, data = gl_data_1011, trans.rate = trans.rate_ard, turnover = c(1, 1, 2, 2, 3, 3, 4, 4), eps = c(1,1,2,2,3,3,4,4), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),

    tar_target(cid_pl_ard, hisse::hisse(phy = data_1011$phy, data = pl_data_1011, trans.rate = trans.rate_ard, turnover = c(1, 1, 2, 2, 3, 3, 4, 4), eps = c(1,1,2,2,3,3,4,4), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))), 

# CID one dimension ER

    tar_target(cid_fr_er, hisse::hisse(phy = data_1011$phy, data = fr_data_1011, trans.rate = trans.rate_er, turnover = c(1, 1, 2, 2, 3, 3, 4, 4), eps = c(1,1,2,2,3,3,4,4), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),

    tar_target(cid_fl_er, hisse::hisse(phy = data_1011$phy, data = fl_data_1011, trans.rate = trans.rate_er, turnover = c(1, 1, 2, 2, 3, 3, 4, 4), eps = c(1,1,2,2,3,3,4,4), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),

    tar_target(cid_gr_er, hisse::hisse(phy = data_1011$phy, data = gr_data_1011, trans.rate = trans.rate_er, turnover = c(1, 1, 2, 2, 3, 3, 4, 4), eps = c(1,1,2,2,3,3,4,4), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),
  
    tar_target(cid_gl_er, hisse::hisse(phy = data_1011$phy, data = gl_data_1011, trans.rate = trans.rate_er, turnover = c(1, 1, 2, 2, 3, 3, 4, 4), eps = c(1,1,2,2,3,3,4,4), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),

    tar_target(cid_pl_er, hisse::hisse(phy = data_1011$phy, data = pl_data_1011, trans.rate = trans.rate_er, turnover = c(1, 1, 2, 2, 3, 3, 4, 4), eps = c(1,1,2,2,3,3,4,4), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))), 

# Hisse with 4 hidden states ARD

# GR
    tar_target(gr_hisse_ard, hisse::hisse(phy = data_1011$phy, data = gr_data_1011, trans.rate = trans.rate_ard, turnover = c(1, 2, 3, 4, 5, 6, 7, 8), eps = c(1,2, 3, 4, 5, 6, 7, 8), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),

# GL
    tar_target(gl_hisse_ard, hisse::hisse(phy = data_1011$phy, data = gl_data_1011, trans.rate = trans.rate_ard, turnover = c(1, 2, 3, 4, 5, 6, 7, 8), eps = c(1,2, 3, 4, 5, 6, 7, 8), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),

# FR
    tar_target(fr_hisse_ard, hisse::hisse(phy = data_1011$phy, data = fr_data_1011, trans.rate = trans.rate_ard, turnover = c(1, 2, 3, 4, 5, 6, 7, 8), eps = c(1,2, 3, 4, 5, 6, 7, 8), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),

# FL
    tar_target(fl_hisse_ard, hisse::hisse(phy = data_1011$phy, data = fl_data_1011, trans.rate = trans.rate_ard, turnover = c(1, 2, 3, 4, 5, 6, 7, 8), eps = c(1,2, 3, 4, 5, 6, 7, 8), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),   

# PL
    tar_target(pl_hisse_ard, hisse::hisse(phy = data_1011$phy, data = pl_data_1011, trans.rate = trans.rate_ard, turnover = c(1, 2, 3, 4, 5, 6, 7, 8), eps = c(1,2, 3, 4, 5, 6, 7, 8), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),   

# Hisse with 4 hidden states ER

# GR
    tar_target(gr_hisse_er, hisse::hisse(phy = data_1011$phy, data = gr_data_1011, trans.rate = trans.rate_er, turnover = c(1, 2, 3, 4, 5, 6, 7, 8), eps = c(1,2, 3, 4, 5, 6, 7, 8), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),

# GL
    tar_target(gl_hisse_er, hisse::hisse(phy = data_1011$phy, data = gl_data_1011, trans.rate = trans.rate_er, turnover = c(1, 2, 3, 4, 5, 6, 7, 8), eps = c(1,2, 3, 4, 5, 6, 7, 8), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),

# FR
    tar_target(fr_hisse_er, hisse::hisse(phy = data_1011$phy, data = fr_data_1011, trans.rate = trans.rate_er, turnover = c(1, 2, 3, 4, 5, 6, 7, 8), eps = c(1,2, 3, 4, 5, 6, 7, 8), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),

# FL
    tar_target(fl_hisse_er, hisse::hisse(phy = data_1011$phy, data = fl_data_1011, trans.rate = trans.rate_er, turnover = c(1, 2, 3, 4, 5, 6, 7, 8), eps = c(1,2, 3, 4, 5, 6, 7, 8), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),   

# PL
    tar_target(pl_hisse_er, hisse::hisse(phy = data_1011$phy, data = pl_data_1011, trans.rate = trans.rate_er, turnover = c(1, 2, 3, 4, 5, 6, 7, 8), eps = c(1,2, 3, 4, 5, 6, 7, 8), hidden.states = TRUE, f = c(0.004044, 0.004044), tip.fog = c(1, 1))),   

# CID two dimension ARD 

# GRGL
    tar_target(cid_gr_gl_ard, hisse::MuHiSSE(phy = data$phy, data = gr_gl_data, trans.rate = trans.rate_ard_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#GRFR
    tar_target(cid_gr_fr_ard, hisse::MuHiSSE(phy = data$phy, data = gr_fr_data, trans.rate = trans.rate_ard_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#GRFL
    tar_target(cid_gr_fl_ard, hisse::MuHiSSE(phy = data$phy, data = gr_fl_data, trans.rate = trans.rate_ard_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#GRPL
    tar_target(cid_gr_pl_ard, hisse::MuHiSSE(phy = data$phy, data = gr_pl_data, trans.rate = trans.rate_ard_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#GLFR
    tar_target(cid_gl_fr_ard, hisse::MuHiSSE(phy = data$phy, data = gl_fr_data, trans.rate = trans.rate_ard_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#GLFL
    tar_target(cid_gl_fl_ard, hisse::MuHiSSE(phy = data$phy, data = gl_fl_data, trans.rate = trans.rate_ard_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#GLPL
    tar_target(cid_gl_pl_ard, hisse::MuHiSSE(phy = data$phy, data = gl_pl_data, trans.rate = trans.rate_ard_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#FRFL
    tar_target(cid_fr_fl_ard, hisse::MuHiSSE(phy = data$phy, data = fr_fl_data, trans.rate = trans.rate_ard_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#FRPL
    tar_target(cid_fr_pl_ard, hisse::MuHiSSE(phy = data$phy, data = fr_pl_data, trans.rate = trans.rate_ard_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#FLPL
    tar_target(cid_fl_pl_ard, hisse::MuHiSSE(phy = data$phy, data = fl_pl_data, trans.rate = trans.rate_ard_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),


# CID two dimension ER 

# GRGL
    tar_target(cid_gr_gl_er, hisse::MuHiSSE(phy = data$phy, data = gr_gl_data, trans.rate = trans.rate_er_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#GRFR
    tar_target(cid_gr_fr_er, hisse::MuHiSSE(phy = data$phy, data = gr_fr_data, trans.rate = trans.rate_er_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#GRFL
    tar_target(cid_gr_fl_er, hisse::MuHiSSE(phy = data$phy, data = gr_fl_data, trans.rate = trans.rate_er_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#GRPL
    tar_target(cid_gr_pl_er, hisse::MuHiSSE(phy = data$phy, data = gr_pl_data, trans.rate = trans.rate_er_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#GLFR
    tar_target(cid_gl_fr_er, hisse::MuHiSSE(phy = data$phy, data = gl_fr_data, trans.rate = trans.rate_er_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#GLFL
    tar_target(cid_gl_fl_er, hisse::MuHiSSE(phy = data$phy, data = gl_fl_data, trans.rate = trans.rate_er_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#GLPL
    tar_target(cid_gl_pl_er, hisse::MuHiSSE(phy = data$phy, data = gl_pl_data, trans.rate = trans.rate_er_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#FRFL
    tar_target(cid_fr_fl_er, hisse::MuHiSSE(phy = data$phy, data = fr_fl_data, trans.rate = trans.rate_er_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#FRPL
    tar_target(cid_fr_pl_er, hisse::MuHiSSE(phy = data$phy, data = fr_pl_data, trans.rate = trans.rate_er_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

#FLPL
    tar_target(cid_fl_pl_er, hisse::MuHiSSE(phy = data$phy, data = fl_pl_data, trans.rate = trans.rate_er_mu, turnover = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), eps = c(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4), hidden.states = TRUE)),

# MuHisse with 4 hidden states ARD 

# GRGL
    tar_target(gr_gl_muhisse_ard, hisse::MuHiSSE(phy = data$phy, data = gr_gl_data, trans.rate = trans.rate_ard_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# GRFR
    tar_target(gr_fr_muhisse_ard, hisse::MuHiSSE(phy = data$phy, data = gr_fr_data, trans.rate = trans.rate_ard_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# GRFL
    tar_target(gr_fl_muhisse_ard, hisse::MuHiSSE(phy = data$phy, data = gr_fl_data, trans.rate = trans.rate_ard_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# GRPL
    tar_target(gr_pl_muhisse_ard, hisse::MuHiSSE(phy = data$phy, data = gr_pl_data, trans.rate = trans.rate_ard_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# GLFR
    tar_target(gl_fr_muhisse_ard, hisse::MuHiSSE(phy = data$phy, data = gl_fr_data, trans.rate = trans.rate_ard_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# GLFL
    tar_target(gl_fl_muhisse_ard, hisse::MuHiSSE(phy = data$phy, data = gl_fl_data, trans.rate = trans.rate_ard_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# GLPL
    tar_target(gl_pl_muhisse_ard, hisse::MuHiSSE(phy = data$phy, data = gl_pl_data, trans.rate = trans.rate_ard_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# FRFL
    tar_target(fr_fl_muhisse_ard, hisse::MuHiSSE(phy = data$phy, data = fr_fl_data, trans.rate = trans.rate_ard_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# FRPL
    tar_target(fr_pl_muhisse_ard, hisse::MuHiSSE(phy = data$phy, data = fr_pl_data, trans.rate = trans.rate_ard_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# FLPL
    tar_target(fl_pl_muhisse_ard, hisse::MuHiSSE(phy = data$phy, data = fl_pl_data, trans.rate = trans.rate_ard_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# MuHisse with 4 hidden states ER 

# GRGL
    tar_target(gr_gl_muhisse_er, hisse::MuHiSSE(phy = data$phy, data = gr_gl_data, trans.rate = trans.rate_er_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# GRFR
    tar_target(gr_fr_muhisse_er, hisse::MuHiSSE(phy = data$phy, data = gr_fr_data, trans.rate = trans.rate_er_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# GRFL
    tar_target(gr_fl_muhisse_er, hisse::MuHiSSE(phy = data$phy, data = gr_fl_data, trans.rate = trans.rate_er_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# GRPL
    tar_target(gr_pl_muhisse_er, hisse::MuHiSSE(phy = data$phy, data = gr_pl_data, trans.rate = trans.rate_er_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# GLFR
    tar_target(gl_fr_muhisse_er, hisse::MuHiSSE(phy = data$phy, data = gl_fr_data, trans.rate = trans.rate_er_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# GLFL
    tar_target(gl_fl_muhisse_er, hisse::MuHiSSE(phy = data$phy, data = gl_fl_data, trans.rate = trans.rate_er_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# GLPL
    tar_target(gl_pl_muhisse_er, hisse::MuHiSSE(phy = data$phy, data = gl_pl_data, trans.rate = trans.rate_er_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# FRFL
    tar_target(fr_fl_muhisse_er, hisse::MuHiSSE(phy = data$phy, data = fr_fl_data, trans.rate = trans.rate_er_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# FRPL
    tar_target(fr_pl_muhisse_er, hisse::MuHiSSE(phy = data$phy, data = fr_pl_data, trans.rate = trans.rate_er_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE)),

# FLPL
    tar_target(fl_pl_muhisse_er, hisse::MuHiSSE(phy = data$phy, data = fl_pl_data, trans.rate = trans.rate_er_mu, turnover = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), eps = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), hidden.states = TRUE))

)
