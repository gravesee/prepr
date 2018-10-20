Preparation R
-------------

This package is used to temporarily relieve swelling, burning, pain, and
itching caused by data preparation.

    x <- rnorm(1000)
    ## add some NAs
    x[sample(length(x), 250)] <- NA

    minmax <- prep_center(method="min") %|>% prep_scale(method="range")
    normalize <- prep_center(method="mean") %|>% prep_scale(method="sd")
    impute <- prep_impute(value=-3)

    hist(predict(minmax, x))

![](readme_files/figure-markdown_strict/unnamed-chunk-1-1.png)

    hist(predict(normalize, x))

![](readme_files/figure-markdown_strict/unnamed-chunk-1-2.png)

    ## compose further
    combo <- minmax %|>% impute

    hist(predict(combo, x))

![](readme_files/figure-markdown_strict/unnamed-chunk-1-3.png)
