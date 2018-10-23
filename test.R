## Create a
data(titanic, package="onyx")

data(mtcars)
mtcars$cyl <- factor(mtcars$cyl)


## TODO:: Pass columns from pipeline to transformers and take intersection

p <- pipeline(
  Survived~., data=titanic,
  prep_filter(~is.na(Age), axis=1L),
  prep_numfactor(method="mean"),
  prep_minmax(min=-1, max=1)) ## Fix this error, too


p$fit(titanic)

p$transform(titanic)

p <- prep_filter(~is.na(Age), axis=1L)

x <- formula(Survived~., data=titanic) %|>% prep_filter(~is.na(Age), axis=1L)


¶

p$fit(titanic, overwrite=TRUE, y=titanic$Survived)


p$transform(titanic[-1])

prep_filter(~is.na(Age), axis=1L)
fit(titanic[-1])

p2 <- prep_numfactor(method="woe", y=Survived) %|>% prep_onehot()
p2$fit(titanic)


p3 <- p1 %|>% p2

p3$isfit <- TRUE
p3$transform(titanic[-1])


p$fit(titanic, overwrite=TRUE)

x <- p$transform(titanic)





library(magrittr)

p$transform(titanic) %>% as.matrix %>% xgboost::xgb.DMatrix(label=titanic$Survived)


p$transform(mtcars)
