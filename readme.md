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

### Piplines

Pipelines simply chain together transformers in a list. They implement
the Transformer API as well and support the same methods:

    ## chain together in a pipeline
    p <- pipeline(
      StandardScaler(),
      MinMaxScaler(feature_range=c(-1, 1))
    )

    z <- p$fit_transform(mtcars)
    mtcars2 <- p$inverse_transform(z)

    ## verify the pipeline can be undone
    all.equal(mtcars, mtcars2)

    ## [1] TRUE
