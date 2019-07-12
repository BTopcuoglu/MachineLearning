REFS = data/references
FIGS = results/figures
TABLES = results/tables
TEMP = data/temp
PROC = data/process
FINAL = submission/
CODE = code/learning

print-%:
	@echo '$*=$($*)'
################################################################################
#
# Part 1: Retrieve the subsampled shared file, taxonomy and metadata files that Marc Sze
# published in https://github.com/SchlossLab/Sze_CRCMetaAnalysis_mBio_2018
#
#	Copy from Github
#
################################################################################

data/baxter.0.03.subsample.shared\
data/metadata.tsv	:	code/learning/load_datasets.batch
	bash code/learning/load_datasets.batch

################################################################################
#
# Part 2: Model analysis in R
#
#	Run scripts to perform all the models on the dataset and generate AUC values
#	Each model has to be submitted seperately.
#	These will generate 100 datasplit results for 7 models
#
################################################################################
$(PROC)/traintime_XGBoost_%.csv\
$(PROC)/all_imp_features_cor_results_XGBoost_%.csv\
$(PROC)/all_imp_features_non_cor_results_XGBoost_%.csv\
$(PROC)/all_hp_results_XGBoost_%.csv\
$(PROC)/best_hp_results_XGBoost_%.csv	:	data/baxter.0.03.subsample.shared\
														data/metadata.tsv\
														$(CODE)/generateAUCs.R\
														$(CODE)/model_pipeline.R\
														$(CODE)/model_interpret.R\
														$(CODE)/main.R\
														$(CODE)/model_selection.R
			Rscript code/learning/main.R $* "XGBoost"


$(PROC)/traintime_Random_Forest_%.csv\
$(PROC)/all_imp_features_cor_results_Random_Forest_%.csv\
$(PROC)/all_imp_features_non_cor_results_Random_Forest_%.csv\
$(PROC)/all_hp_results_Random_Forest_%.csv\
$(PROC)/best_hp_results_Random_Forest_%.csv	:	data/baxter.0.03.subsample.shared\
														data/metadata.tsv\
														$(CODE)/generateAUCs.R\
														$(CODE)/model_pipeline.R\
														$(CODE)/model_interpret.R\
														$(CODE)/main.R\
														$(CODE)/model_selection.R
			Rscript code/learning/main.R $* "Random_Forest"

$(PROC)/traintime_Decision_Tree_%.csv\
$(PROC)/all_imp_features_cor_results_Decision_Tree_%.csv\
$(PROC)/all_imp_features_non_cor_results_Decision_Tree_%.csv\
$(PROC)/all_hp_results_Decision_Tree_%.csv\
$(PROC)/best_hp_results_Decision_Tree_%.csv	:	data/baxter.0.03.subsample.shared\
														data/metadata.tsv\
														$(CODE)/generateAUCs.R\
														$(CODE)/model_pipeline.R\
														$(CODE)/model_interpret.R\
														$(CODE)/main.R\
														$(CODE)/model_selection.R
			Rscript code/learning/main.R $* "Decision_Tree"

$(PROC)/traintime_RBF_SVM_%.csv\
$(PROC)/all_imp_features_cor_results_RBF_SVM_%.csv\
$(PROC)/all_imp_features_non_cor_results_RBF_SVM_%.csv\
$(PROC)/all_hp_results_RBF_SVM_%.csv\
$(PROC)/best_hp_results_RBF_SVM_%.csv	:	data/baxter.0.03.subsample.shared\
														data/metadata.tsv\
														$(CODE)/generateAUCs.R\
														$(CODE)/model_pipeline.R\
														$(CODE)/model_interpret.R\
														$(CODE)/main.R\
														$(CODE)/model_selection.R
			Rscript code/learning/main.R $* "RBF_SVM"

$(PROC)/traintime_L1_Linear_SVM_%.csv\
$(PROC)/all_imp_features_cor_results_L1_Linear_SVM_%.csv\
$(PROC)/all_imp_features_non_cor_results_L1_Linear_SVM_%.csv\
$(PROC)/all_hp_results_L1_Linear_SVM_%.csv\
$(PROC)/best_hp_results_L1_Linear_SVM_%.csv	:	data/baxter.0.03.subsample.shared\
														data/metadata.tsv\
														$(CODE)/generateAUCs.R\
														$(CODE)/model_pipeline.R\
														$(CODE)/model_interpret.R\
														$(CODE)/main.R\
														$(CODE)/model_selection.R
			Rscript code/learning/main.R $* "L1_Linear_SVM"

$(PROC)/traintime_L2_Linear_SVM_%.csv\
$(PROC)/all_imp_features_cor_results_L2_Linear_SVM_%.csv\
$(PROC)/all_imp_features_non_cor_results_L2_Linear_SVM_%.csv\
$(PROC)/all_hp_results_L2_Linear_SVM_%.csv\
$(PROC)/best_hp_results_L2_Linear_SVM_%.csv	:	data/baxter.0.03.subsample.shared\
														data/metadata.tsv\
														$(CODE)/generateAUCs.R\
														$(CODE)/model_pipeline.R\
														$(CODE)/model_interpret.R\
														$(CODE)/main.R\
														$(CODE)/model_selection.R
			Rscript code/learning/main.R $* "L2_Linear_SVM"

$(PROC)/traintime_L2_Logistic_Regression_%.csv\
$(PROC)/all_imp_features_cor_results_L2_Logistic_Regression_%.csv\
$(PROC)/all_imp_features_non_cor_results_L2_Logistic_Regression_%.csv\
$(PROC)/all_hp_results_L2_Logistic_Regression_%.csv\
$(PROC)/best_hp_results_L2_Logistic_Regression_%.csv	:	data/baxter.0.03.subsample.shared\
														data/metadata.tsv\
														$(CODE)/generateAUCs.R\
														$(CODE)/model_pipeline.R\
														$(CODE)/model_interpret.R\
														$(CODE)/main.R\
														$(CODE)/model_selection.R
			Rscript code/learning/main.R $* "L2_Logistic_Regression"

SEEDS=$(shell seq 0 99)

L2_LOGISTIC_REGRESSION_BEST_REPS=$(foreach S,$(SEEDS),$(PROC)/best_hp_results_L2_Logistic_Regression_$(S).csv)
L2_LOGISTIC_REGRESSION_ALL_REPS=$(foreach S,$(SEEDS),$(PROC)/all_hp_results_L2_Logistic_Regression_$(S).csv)
L2_LOGISTIC_REGRESSION_COR_IMP_REPS=$(foreach S,$(SEEDS),$(PROC)/all_imp_features_cor_results_L2_Logistic_Regression_$(S).csv)
L2_LOGISTIC_REGRESSION_NON_COR_IMP_REPS=$(foreach S,$(SEEDS),$(PROC)/all_imp_features_non_cor_results_L2_Logistic_Regression_$(S).csv)
L2_LOGISTIC_REGRESSION_TIME_REPS=$(foreach S,$(SEEDS),$(PROC)/traintime_L2_Logistic_Regression_$(S).csv)

L2_LINEAR_SVM_BEST_REPS=$(foreach S,$(SEEDS),$(PROC)/best_hp_results_L2_Linear_SVM_$(S).csv)
L2_LINEAR_SVM_ALL_REPS=$(foreach S,$(SEEDS),$(PROC)/all_hp_results_L2_Linear_SVM_$(S).csv)
L2_LINEAR_SVM_COR_IMP_REPS=$(foreach S,$(SEEDS),$(PROC)/all_imp_features_cor_results_L2_Linear_SVM_$(S).csv)
L2_LINEAR_SVM_NON_COR_IMP_REPS=$(foreach S,$(SEEDS),$(PROC)/all_imp_features_non_cor_results_L2_Linear_SVM_$(S).csv)
L2_LINEAR_SVM_TIME_REPS=$(foreach S,$(SEEDS),$(PROC)/traintime_L2_Linear_SVM_$(S).csv)

L1_LINEAR_SVM_BEST_REPS=$(foreach S,$(SEEDS),$(PROC)/best_hp_results_L1_Linear_SVM_$(S).csv)
L1_LINEAR_SVM_ALL_REPS=$(foreach S,$(SEEDS),$(PROC)/all_hp_results_L1_Linear_SVM_$(S).csv)
L1_LINEAR_SVM_COR_IMP_REPS=$(foreach S,$(SEEDS),$(PROC)/all_imp_features_cor_results_L1_Linear_SVM_$(S).csv)
L1_LINEAR_SVM_NON_COR_IMP_REPS=$(foreach S,$(SEEDS),$(PROC)/all_imp_features_non_cor_results_L1_Linear_SVM_$(S).csv)
L1_LINEAR_SVM_TIME_REPS=$(foreach S,$(SEEDS),$(PROC)/traintime_L1_Linear_SVM_$(S).csv)

RBF_SVM_BEST_REPS=$(foreach S,$(SEEDS),$(PROC)/best_hp_results_RBF_SVM_$(S).csv)
RBF_SVM_ALL_REPS=$(foreach S,$(SEEDS),$(PROC)/all_hp_results_RBF_SVM_$(S).csv)
RBF_SVM_COR_IMP_REPS=$(foreach S,$(SEEDS),$(PROC)/all_imp_features_cor_results_RBF_SVM_$(S).csv)
RBF_SVM_NON_COR_IMP_REPS=$(foreach S,$(SEEDS),$(PROC)/all_imp_features_non_cor_results_RBF_SVM_$(S).csv)
RBF_SVM_TIME_REPS=$(foreach S,$(SEEDS),$(PROC)/traintime_RBF_SVM_$(S).csv)

Decision_Tree_BEST_REPS=$(foreach S,$(SEEDS),$(PROC)/best_hp_results_Decision_Tree_$(S).csv)
Decision_Tree_ALL_REPS=$(foreach S,$(SEEDS),$(PROC)/all_hp_results_Decision_Tree_$(S).csv)
Decision_Tree_COR_IMP_REPS=$(foreach S,$(SEEDS),$(PROC)/all_imp_features_cor_results_Decision_Tree_$(S).csv)
Decision_Tree_NON_COR_IMP_REPS=$(foreach S,$(SEEDS),$(PROC)/all_imp_features_non_cor_results_Decision_Tree_$(S).csv)
Decision_Tree_TIME_REPS=$(foreach S,$(SEEDS),$(PROC)/traintime_Decision_Tree_$(S).csv)

Random_Forest_BEST_REPS=$(foreach S,$(SEEDS),$(PROC)/best_hp_results_Random_Forest_$(S).csv)
Random_Forest_ALL_REPS=$(foreach S,$(SEEDS),$(PROC)/all_hp_results_Random_Forest_$(S).csv)
Random_Forest_COR_IMP_REPS=$(foreach S,$(SEEDS),$(PROC)/all_imp_features_cor_results_Random_Forest_$(S).csv)
Random_Forest_NON_COR_IMP_REPS=$(foreach S,$(SEEDS),$(PROC)/all_imp_features_non_cor_results_Random_Forest_$(S).csv)
Random_Forest_TIME_REPS=$(foreach S,$(SEEDS),$(PROC)/traintime_Random_Forest_$(S).csv)

XGBoost_BEST_REPS=$(foreach S,$(SEEDS),$(PROC)/best_hp_results_XGBoost_$(S).csv)
XGBoost_ALL_REPS=$(foreach S,$(SEEDS),$(PROC)/all_hp_results_XGBoost_$(S).csv)
XGBoost_COR_IMP_REPS=$(foreach S,$(SEEDS),$(PROC)/all_imp_features_cor_results_XGBoost_$(S).csv)
XGBoost_NON_COR_IMP_REPS=$(foreach S,$(SEEDS),$(PROC)/all_imp_features_non_cor_results_XGBoost_$(S).csv)
XGBoost_TIME_REPS=$(foreach S,$(SEEDS),$(PROC)/traintime_XGBoost_$(S).csv)

# Combine all the files generated from each submitted job

$(PROC)/combined_best_hp_results_XGBoost.csv\
$(PROC)/combined_best_hp_results_Random_Forest.csv\
$(PROC)/combined_best_hp_results_Decision_Tree.csv\
$(PROC)/combined_best_hp_results_RBF_SVM.csv\
$(PROC)/combined_best_hp_results_L2_Logistic_Regression.csv\
$(PROC)/combined_best_hp_results_L1_Linear_SVM.csv\
$(PROC)/combined_best_hp_results_L2_Linear_SVM.csv\
$(PROC)/combined_all_hp_results_XGBoost.csv\
$(PROC)/combined_all_hp_results_Random_Forest.csv\
$(PROC)/combined_all_hp_results_Decision_Tree.csv\
$(PROC)/combined_all_hp_results_RBF_SVM.csv\
$(PROC)/combined_all_hp_results_L2_Logistic_Regression.csv\
$(PROC)/combined_all_hp_results_L1_Linear_SVM.csv\
$(PROC)/combined_all_hp_results_L2_Linear_SVM.csv\
$(PROC)/combined_all_imp_features_cor_results_Decision_Tree.csv\
$(PROC)/combined_all_imp_features_cor_results_L1_Linear_SVM.csv\
$(PROC)/combined_all_imp_features_cor_results_L2_Linear_SVM.csv\
$(PROC)/combined_all_imp_features_cor_results_L2_Logistic_Regression.csv\
$(PROC)/combined_all_imp_features_cor_results_Random_Forest.csv\
$(PROC)/combined_all_imp_features_cor_results_RBF_SVM.csv\
$(PROC)/combined_all_imp_features_cor_results_XGBoost.csv\
$(PROC)/combined_all_imp_features_non_cor_results_Decision_Tree.csv\
$(PROC)/combined_all_imp_features_non_cor_results_L1_Linear_SVM.csv\
$(PROC)/combined_all_imp_features_non_cor_results_L2_Linear_SVM.csv\
$(PROC)/combined_all_imp_features_non_cor_results_L2_Logistic_Regression.csv\
$(PROC)/combined_all_imp_features_non_cor_results_Random_Forest.csv\
$(PROC)/combined_all_imp_features_non_cor_results_RBF_SVM.csv\
$(PROC)/combined_all_imp_features_non_cor_results_XGBoost.csv\
$(PROC)/traintime_XGBoost.csv\
$(PROC)/traintime_Random_Forest.csv\
$(PROC)/traintime_Decision_Tree.csv\
$(PROC)/traintime_RBF_SVM.csv\
$(PROC)/traintime_L1_Linear_SVM.csv\
$(PROC)/traintime_L2_Linear_SVM.csv\
$(PROC)/traintime_L2_Logistic_Regression.csv	:	$(L2_LINEAR_SVM_REPS)\
												$(L2_LOGISTIC_REGRESSION_BEST_REPS)\
												$(L2_LOGISTIC_REGRESSION_ALL_REPS)\
												$(L2_LOGISTIC_REGRESSION_COR_IMP_REPS)\
												$(L2_LOGISTIC_REGRESSION_NON_COR_IMP_REPS)\
												$(L2_LOGISTIC_REGRESSION_TIME_REPS)\
												$(L2_LINEAR_SVM_BEST_REPS)\
												$(L2_LINEAR_SVM_ALL_REPS)\
												$(L2_LINEAR_SVM_COR_IMP_REPS)\
												$(L2_LINEAR_SVM_NON_COR_IMP_REPS)\
												$(L2_LINEAR_SVM_TIME_REPS)\
												$(L1_LINEAR_SVM_BEST_REPS)\
												$(L1_LINEAR_SVM_ALL_REPS)\
												$(L1_LINEAR_SVM_COR_IMP_REPS)\
												$(L1_LINEAR_SVM_NON_COR_IMP_REPS)\
												$(L1_LINEAR_SVM_TIME_REPS)\
												$(RBF_SVM_BEST_REPS)\
												$(RBF_SVM_ALL_REPS)\
												$(RBF_SVM_COR_IMP_REPS)\
												$(RBF_SVM_NON_COR_IMP_REPS)\
												$(RBF_SVM_TIME_REPS)\
												$(Decision_Tree_BEST_REPS)\
												$(Decision_Tree_ALL_REPS)\
												$(Decision_Tree_COR_IMP_REPS)\
												$(Decision_Tree_NON_COR_IMP_REPS)\
												$(Decision_Tree_TIME_REPS)\
												$(Random_Forest_BEST_REPS)\
												$(Random_Forest_ALL_REPS)\
												$(Random_Forest_COR_IMP_REPS)\
												$(Random_Forest_NON_COR_IMP_REPS)\
												$(Random_Forest_TIME_REPS)\
												$(XGBoost_BEST_REPS)\
												$(XGBoost_ALL_REPS)\
												$(XGBoost_COR_IMP_REPS)\
												$(XGBoost_NON_COR_IMP_REPS)\
												$(XGBoost_TIME_REPS)\
												code/cat_csv_files.sh
	bash code/cat_csv_files.sh

# Take the individual correlated importance files and create feature rankings for each datasplit
# Then combine each feature ranking into 1 combined file
DATA=feature_ranking

$(PROC)/combined_L1_Linear_SVM_$(DATA).tsv\
$(PROC)/combined_L2_Linear_SVM_$(DATA).tsv\
$(PROC)/combined_L2_Logistic_Regression_$(DATA).tsv	:	$(L2_LOGISTIC_REGRESSION_COR_IMP_REPS)\
												$(L1_LINEAR_SVM_COR_IMP_REPS)\
												$(L2_LINEAR_SVM_COR_IMP_REPS)\
												code/learning/get_feature_rankings.R\
												code/merge_feature_ranks.sh
	Rscript code/learning/get_feature_rankings\
	bash code/merge_feature_ranks.sh





################################################################################
#
# Part 3: Figure and table generation
#
#	Run scripts to generate figures and tables
#
################################################################################

# Figure 1 shows the generalization performance of all the models tested.
$(FIGS)/Figure_1.pdf	:	$(CODE)/functions.R\
							$(CODE)/Figure1.R\
							$(PROC)/combined_best_hp_results_XGBoost.csv\
							$(PROC)/combined_best_hp_results_Random_Forest.csv\
							$(PROC)/combined_best_hp_results_Decision_Tree.csv\
							$(PROC)/combined_best_hp_results_RBF_SVM.csv\
							$(PROC)/combined_best_hp_results_L2_Logistic_Regression.csv\
							$(PROC)/combined_best_hp_results_L1_Linear_SVM.csv\
							$(PROC)/combined_best_hp_results_L2_Linear_SVM.csv
					Rscript $(CODE)/Figure1.R

# Figure 2 shows the hyper-parameter tuning of all the models tested.
$(FIGS)/Figure_2.pdf	:	$(CODE)/functions.R\
							$(CODE)/Figure2.R\
							$(PROC)/combined_all_hp_results_XGBoost.csv\
							$(PROC)/combined_all_hp_results_Random_Forest.csv\
							$(PROC)/combined_all_hp_results_Decision_Tree.csv\
							$(PROC)/combined_all_hp_results_RBF_SVM.csv\
							$(PROC)/combined_all_hp_results_L2_Logistic_Regression.csv\
							$(PROC)/combined_all_hp_results_L1_Linear_SVM.csv\
							$(PROC)/combined_all_hp_results_L2_Linear_SVM.csv
					Rscript $(CODE)/Figure2.R

# Figure 2 shows the hyper-parameter tuning of all the models tested.
$(FIGS)/Figure_3.pdf	:	$(CODE)/functions.R\
							$(CODE)/Figure3.R\
							$(PROC)/traintime_XGBoost.csv\
							$(PROC)/traintime_Random_Forest.csv\
							$(PROC)/traintime_Decision_Tree.csv\
							$(PROC)/traintime_RBF_SVM.csv\
							$(PROC)/traintime_L2_Logistic_Regression.csv\
							$(PROC)/traintime_L1_Linear_SVM.csv\
							$(PROC)/traintime_L2_Linear_SVM.csv
					Rscript $(CODE)/Figure3.R


$(FIGS)/Figure_4.pdf	:	$(CODE)/functions.R\
							$(CODE)/Figure4.R\
							$(PROC)/combined_all_imp_features_results_Decision_Tree.csv\
							$(PROC)/combined_all_imp_features_results_L1_Linear_SVM.csv\
							$(PROC)/combined_all_imp_features_results_L2_Linear_SVM.csv\
							$(PROC)/combined_all_imp_features_results_L2_Logistic_Regression.csv\
							$(PROC)/combined_all_imp_features_results_Random_Forest.csv\
							$(PROC)/combined_all_imp_features_results_RBF_SVM.csv\
							$(PROC)/combined_all_imp_features_results_XGBoost.csv
					Rscript $(CODE)/Figure4.R


# Table 1 is a summary of the properties of all the models tested.
#$(TABLES)/Table1.pdf :	$(PROC)/model_parameters.txt\#
#						$(TABLES)/Table1.Rmd\#
#						$(TABLES)/header.tex#
#	R -e "rmarkdown::render('$(TABLES)/Table1.Rmd', clean=TRUE)"
#	rm $(TABLES)/Table1.tex









################################################################################
#
# Part 4: Pull it all together
#
# Render the manuscript
#
################################################################################


#$(FINAL)/manuscript.% : 			\ #include data files that are needed for paper don't leave this line with a : \
#						$(FINAL)/mbio.csl\#
#						$(FINAL)/references.bib\#
#						$(FINAL)/manuscript.Rmd#
#	R -e 'render("$(FINAL)/manuscript.Rmd", clean=FALSE)'
#	mv $(FINAL)/manuscript.knit.md submission/manuscript.md
#	rm $(FINAL)/manuscript.utf8.md


#write.paper : $(TABLES)/table_1.pdf $(TABLES)/table_2.pdf\ #customize to include
#				$(FIGS)/figure_1.pdf $(FIGS)/figure_2.pdf\	# appropriate tables and
#				$(FIGS)/figure_3.pdf $(FIGS)/figure_4.pdf\	# figures
#				$(FINAL)/manuscript.Rmd $(FINAL)/manuscript.md\#
#				$(FINAL)/manuscript.tex $(FINAL)/manuscript.pdf
