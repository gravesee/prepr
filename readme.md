Preparation R
-------------

This package is used to temporarily relieve swelling, burning, pain, and
itching caused by data preparation. Heavily influenced by sklearn
preprocessing module. As such it aims to implement the Transformer API
and allow for pipelines that can be saved and applied to new datasets.

It will eventually include methods for outputting to PMML or json to
assist with productionalizing data preparation steps.

    ## create a standard normalization scaler
    s <- StandardScaler()

    ## fit the scaler using a data.frame
    s$fit(mtcars)

    ## transform each column of data.frame 
    z <- s$transform(mtcars)

    ## unit variance
    sapply(z, sd) 

    ##  mpg  cyl disp   hp drat   wt qsec   vs   am gear carb 
    ##    1    1    1    1    1    1    1    1    1    1    1

    ## verify that the inverse transform is equal to the original data
    all.equal(s$inverse_transform(s$transform(mtcars)), mtcars)

    ## [1] TRUE

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
    lapply(z, range)

    ## $mpg
    ## [1] 10.4 33.9
    ## 
    ## $cyl
    ## [1] 4 8
    ## 
    ## $disp
    ## [1] -1  1
    ## 
    ## $hp
    ## [1] -1  1
    ## 
    ## $drat
    ## [1] 2.76 4.93
    ## 
    ## $wt
    ## [1] -1  1
    ## 
    ## $qsec
    ## [1] 14.5 22.9
    ## 
    ## $vs
    ## [1] 0 1
    ## 
    ## $am
    ## [1] 0 1
    ## 
    ## $gear
    ## [1] 3 5
    ## 
    ## $carb
    ## [1] 1 8

### Piplines

Pipelines simply chain together transformers in a list. They implement
the Transformer API as well and support the same methods. Columns can
also have an optional `cols` argument that will limit all pipeline
operations to the columns specified.

    ## chain together in a pipeline
    p <- pipeline(
      StandardScaler(),
      MinMaxScaler(feature_range=c(-1, 1)))

    z <- p$fit_transform(mtcars)
    mtcars2 <- p$inverse_transform(z)

    ## verify the pipeline can be undone
    all.equal(mtcars, mtcars2)

    ## [1] TRUE

    ## same pipeline with restricted columns
    p <- pipeline(
      StandardScaler(),
      MinMaxScaler(feature_range=c(-1, 1)),
      cols = c("disp", "mpg", "hp"))

    lapply(p$fit_transform(mtcars), summary)

    ## $mpg
    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    ## -1.00000 -0.57234 -0.25106 -0.17527  0.05532  1.00000 
    ## 
    ## $cyl
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   4.000   4.000   6.000   6.188   8.000   8.000 
    ## 
    ## $disp
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ## -1.0000 -0.7519 -0.3754 -0.2037  0.2716  1.0000 
    ## 
    ## $hp
    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    ## -1.00000 -0.68551 -0.49823 -0.33083 -0.09541  1.00000 
    ## 
    ## $drat
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   2.760   3.080   3.695   3.597   3.920   4.930 
    ## 
    ## $wt
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   1.513   2.581   3.325   3.217   3.610   5.424 
    ## 
    ## $qsec
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   14.50   16.89   17.71   17.85   18.90   22.90 
    ## 
    ## $vs
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##  0.0000  0.0000  0.0000  0.4375  1.0000  1.0000 
    ## 
    ## $am
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##  0.0000  0.0000  0.0000  0.4062  1.0000  1.0000 
    ## 
    ## $gear
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   3.000   3.000   4.000   3.688   4.000   5.000 
    ## 
    ## $carb
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   1.000   2.000   2.000   2.812   4.000   8.000
