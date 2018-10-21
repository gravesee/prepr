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
    sapply(z, range)

    ##       mpg cyl disp hp drat wt qsec vs am gear carb
    ## [1,] 10.4   4   -1 -1 2.76 -1 14.5  0  0    3    1
    ## [2,] 33.9   8    1  1 4.93  1 22.9  1  1    5    8

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

    sapply(p$fit_transform(mtcars), range)

    ##      mpg cyl disp hp drat    wt qsec vs am gear carb
    ## [1,]  -1   4   -1 -1 2.76 1.513 14.5  0  0    3    1
    ## [2,]   1   8    1  1 4.93 5.424 22.9  1  1    5    8
