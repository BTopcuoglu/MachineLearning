############## IMPORT MODULES ######################
from sklearn.neighbors.nearest_centroid import NearestCentroid
from sklearn.svm import SVC, LinearSVC
from sklearn.model_selection import cross_val_score
from sklearn import linear_model
from sklearn.model_selection import train_test_split
import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
from sympy import *
import matplotlib.pyplot as plt
from scipy import interp
from sklearn.metrics import roc_curve, auc
from sklearn.model_selection import RepeatedStratifiedKFold
from sklearn.model_selection import GridSearchCV
from sklearn.preprocessing import StandardScaler
from sklearn.externals import joblib


## Read in the data

## shared has our input features(OTUs)
shared = pd.read_table("data/baxter.0.03.subsample.shared")
## meta has the labels(diagnosis)
meta = pd.read_table("data/metadata.tsv")

## Check and visualize the data
meta.head()
shared.head()

## Remove unnecessary columns from meta and only keep label for classification(diagnosis) and the sample name
meta = meta[['sample','dx']]

## Rename the column name "Group" to match the "sample" in meta
shared = shared.rename(index=str, columns={"Group":"sample"})

## Merge the 2 datasets on sample
data=pd.merge(meta,shared,on=['sample'])

## Remove adenoma samples. We will do a 2 classification model, just for cancer and normal colon samples.
data= data[data.dx.str.contains("adenoma") == False]

## Drop all except OTU columns for x
x = data.drop(["sample", "dx", "numOtus", "label"], axis=1)

## Cancer =1 Normal =0
diagnosis = { "cancer":1, "normal":0}

## Generate y which only has diagnosis as 0 and 1
y = data["dx"].replace(diagnosis)
# y = np.eye(2, dtype='uint8')[y]

## Drop if NA elements
y.dropna()
x.dropna()


cv = RepeatedStratifiedKFold(n_splits=5, n_repeats=100, random_state=200889)


###################### Best Parameters #######################
#  Best: 0.747897 using {'C': 1.0, 'gamma': 0.001, 'kernel': 'sigmoid'}
##############################################################

tprs_test = []
aucs_test = []
mean_fpr_test = np.linspace(0, 1, 100)
SVM_plot = plt.figure()

epochs= 100
for epoch in range(epochs):
    ## Split dataset to 80% training 20% test sets.
    x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.2,shuffle=True)

    scaler = StandardScaler().fit(x_train)
    x_train = scaler.transform(x_train)
    x_test = scaler.transform(x_test)

    best_model = SVC(C=1.0, kernel='sigmoid', gamma=0.001)

## Converting to numpy array from pandas

    y_test= y_test.values
    X=x_train
    Y=y_train.values
    tprs = []
    aucs = []
    mean_fpr = np.linspace(0, 1, 100)
    y_score = best_model.fit(x_train, y_train).decision_function(x_test)

    # Compute ROC curve and area the curve
    fpr_test, tpr_test, thresholds_test = roc_curve(y_test, y_score)
    tprs_test.append(interp(mean_fpr_test, fpr_test, tpr_test))
    tprs_test[-1][0] = 0.0
    roc_auc_test = auc(fpr_test, tpr_test)
    aucs_test.append(roc_auc_test)
    print("Test", roc_auc_test)

    for train, test in cv.split(X,Y):
        y_score = best_model.fit(X[train], Y[train]).decision_function(X[test])
        fpr, tpr, thresholds = roc_curve(Y[test], y_score)
        tprs.append(interp(mean_fpr, fpr, tpr))
        tprs[-1][0] = 0.0
        roc_auc = auc(fpr, tpr)
        aucs.append(roc_auc)
        print("Train", roc_auc)
        ## Plot mean ROC curve for test set after each fitting of subset training set


plt.plot([0, 1], [0, 1], linestyle='--', color='green', label='Luck', alpha=.8)
mean_tpr_test = np.mean(tprs_test, axis=0)
mean_tpr_test[-1] = 1.0
mean_auc_test = auc(mean_fpr_test, mean_tpr_test)
std_auc_test = np.std(aucs_test)
plt.plot(mean_fpr_test, mean_tpr_test, color='r', label=r'Never-before-seen test set ROC (AUC = %0.2f $\pm$ %0.2f)' % (mean_auc_test, std_auc_test), lw=2, alpha=.8)
std_tpr_test = np.std(tprs_test, axis=0)
tprs_upper_test = np.minimum(mean_tpr_test + std_tpr_test, 1)
tprs_lower_test = np.maximum(mean_tpr_test - std_tpr_test, 0)
plt.fill_between(mean_fpr_test, tprs_lower_test, tprs_upper_test, color='tomato', alpha=.2, label=r'$\pm$ 1 std. dev.')
mean_tpr = np.mean(tprs, axis=0)
mean_tpr[-1] = 1.0
mean_auc = auc(mean_fpr, mean_tpr)
std_auc = np.std(aucs)
plt.plot(mean_fpr, mean_tpr, color='b', label=r'Mean cross-val ROC (AUC = %0.2f $\pm$ %0.2f)' % (mean_auc, std_auc), lw=2, alpha=.8)
std_tpr = np.std(tprs, axis=0)
tprs_upper = np.minimum(mean_tpr + std_tpr, 1)
tprs_lower = np.maximum(mean_tpr - std_tpr, 0)
plt.fill_between(mean_fpr, tprs_lower, tprs_upper, color='dodgerblue', alpha=.2, label=r'$\pm$ 1 std. dev.')
plt.xlim([-0.05, 1.05])
plt.ylim([-0.05, 1.05])
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('SVM ROC\n')
plt.legend(loc="lower right", fontsize=8)
#plt.show()
SVM_plot.savefig('results/figures/SVM_Baxter.png', dpi=1000)

###### SAVE MODEL TO BE USED ON OTHER DATA #########
filename = 'finalized_SVM_model.sav'
joblib.dump(best_model, filename)
