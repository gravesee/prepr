Preparation R
-------------

This package is used to temporarily relieve swelling, burning, pain, and
itching caused by data preparation. Heavily influenced by sklearn
preprocessing module. As such it aims to implement the Transformer API
and allow for pipelines that can be saved and applied to new datasets.

It will eventually include methods for outputting to PMML or json to
assist with productionalizing data preparation steps.

    ## create a onehot encoder
    oh <- OnehotEncoder(levels=list(Sex="male", Pclass=c("1", "3")))

    ## fit the scaler using a data.frame
    oh$fit(titanic)

    ## transform each column of data.frame 
    head(oh$transform(head(titanic)))

    ##   Survived Age SibSp Parch    Fare Embarked Sex=male Pclass=1 Pclass=3
    ## 1        0  22     1     0  7.2500        S        1        0        1
    ## 2        1  38     1     0 71.2833        C        0        1        0
    ## 3        1  26     0     0  7.9250        S        0        0        1
    ## 4        1  35     1     0 53.1000        S        0        1        0
    ## 5        0  35     0     0  8.0500        S        1        0        1
    ## 6        0  NA     0     0  8.4583        Q        1        0        1

Specify Subset of Columns
-------------------------

All transformers take a `cols` argument. It can be a character vector of
column name which limits the transformer operations to just those
columns. Optionally, "factor" or "numeric" can be specified to limit
opertions to just columns of those types. Most transformers have a
default value for the `cols` argument that makes sense for the
operation.

    mm <- MinMaxScaler(feature_range=c(-1, 1), cols=c("disp", "hp", "wt"))
    z <- mm$fit_transform(mtcars)

    ## only specified columns are transformed
    sapply(z, range)

    ##       mpg cyl disp hp drat wt qsec vs am gear carb
    ## [1,] 10.4   4   -1 -1 2.76 -1 14.5  0  0    3    1
    ## [2,] 33.9   8    1  1 4.93  1 22.9  1  1    5    8

### Pipelines

Pipelines simply chain together transformers in a list. They implement
the Transformer API as well and support the same methods. Columns can
also have an optional `cols` argument that will limit all pipeline
operations to the columns specified.

    ## chain together in a pipeline
    p <- pipeline(
      MinMaxScaler(feature_range=c(-1, 1)),
      StandardImputer(method="median"),
      OnehotEncoder(levels=list(Sex="male", Pclass=c("1", "3"))),
      OnehotEncoder()) ## The rest

    z <- p$fit_transform(titanic[-1])

    head(z)

    ##           Age SibSp Parch       Fare Sex=male Pclass=1 Pclass=3 Embarked=C
    ## 1 -0.45765268 -0.75    -1 -0.9716979        1        0        1          0
    ## 2 -0.05554159 -0.75    -1 -0.7217285        0        1        0          1
    ## 3 -0.35712491 -1.00    -1 -0.9690629        0        0        1          0
    ## 4 -0.13093742 -0.75    -1 -0.7927114        0        1        0          0
    ## 5 -0.13093742 -1.00    -1 -0.9685749        1        0        1          0
    ## 6 -0.30686102 -1.00    -1 -0.9669810        1        0        1          0
    ##   Embarked=Q Embarked=S
    ## 1          0          1
    ## 2          0          0
    ## 3          0          1
    ## 4          0          1
    ## 5          0          1
    ## 6          1          0

Note that the order of the pipeline transformers is important. If you
pass numeric transformers after onehot encoders for example, the onehot
output will be transformed as it is now numeric. As of yet there is no
mechanism for preventing this from happening or warning the user.
