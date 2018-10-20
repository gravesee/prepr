x <- rnorm(1000)

minmax <- prep_center(method="min") %|>% prep_scale(method="range")
normalize <- prep_center(method="mean") %|>% prep_scale(method="sd")
