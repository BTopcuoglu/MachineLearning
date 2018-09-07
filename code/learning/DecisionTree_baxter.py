############## IMPORT MODULES ######################
from sklearn.tree import DecisionTreeClassifier
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



x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.2,shuffle=True)

## Define the n-folds for hyper-parameter optimization on training set.
cv = RepeatedStratifiedKFold(n_splits=5, n_repeats=100, random_state=200889)

## Define Decision Tree Classifier
model = DecisionTreeClassifier()

## Define the hyper-parameters optimization on training set.
params = dict(max_depth=[10, 50, 100, 500, 1000], min_samples_split=[5, 10, 100, 150, 200])

grid = GridSearchCV(estimator = model, param_grid = params, cv = cv, scoring = 'roc_auc')

grid_result = grid.fit(x_train, y_train)

print("Best: %f using %s" % (grid_result.best_score_, grid_result.best_params_))
means = grid_result.cv_results_['mean_test_score']
stds = grid_result.cv_results_['std_test_score']
params = grid_result.cv_results_['params']
for mean, stdev, param in zip(means, stds, params):
    print("%f (%f) with: %r" % (mean, stdev, param))



###################### Best Parameters #######################

##############################################################
