

p <- pipeline(prep_onehot(~Species))


p <- pipeline(
  prep_impute(),
  prep_onehot(~sel_lambda(function(x) sum(x) < 20)),
  prep_binarize(~cyl, levels=1, replace = NA))

p$fit(mtcars)


p <- prep_onehot(~sel_lambda(function(x) sum(x) < 20))


p <-
  prep_impute() %|>%
  prep_onehot(~cyl) %|>%
  prep_binarize(~vs, levels=1, replace = NA)  %|>%
  prep_impute(~vs, method=max)



mtcars$mpg[1:10] <- NA
mtcars$cyl[20:30] <- NA


#p <- prep_onehot(~cyl)
p <- prep_impute()
p$fit_transform(x=mtcars)



p <- prep_onehot(~cyl)
p$fit_transform(mtcars)

p <- pipeline(prep_impute(), prep_onehot(~cyl))
p <- pipeline(prep_onehot(~cyl), prep_impute())

match(mtcars$cyl, unique(mtcars$cyl), nomatch = 0)
