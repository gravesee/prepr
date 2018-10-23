## Create a
data(titanic, package="onyx")

data(mtcars)
mtcars$cyl <- factor(mtcars$cyl)


p <- prep_filter(~is.na(Age), axis=1L)


p$fit(titanic, overwrite=TRUE, y=titanic$Survived)


p$transform(titanic[-1])

p1 <- prep_filter(~is.na(Age), axis=1L)$fit(titanic[-1])

p2 <- prep_numfactor(method="woe", y=Survived) %|>% prep_onehot()






p$fit(titanic, overwrite=TRUE)

x <- p$transform(titanic)





library(magrittr)

p$transform(titanic) %>% as.matrix %>% xgboost::xgb.DMatrix(label=titanic$Survived)




p$transform(mtcars)
