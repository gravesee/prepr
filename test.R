## Create a
data(titanic, package="onyx")

data(mtcars)

mtcars$cyl <- factor(mtcars$cyl)

sf <- StandardFilter(~sum(is.na(x)) > 10, cols=c("mpg","hp"))
sf$fit(mtcars)
sf$transform(mtcars)

ff <- FactorFilter(~all(table(x) > 20))
ff$fit(mtcars)
ff$transform(mtcars)

oh <- OnehotEncoder(levels=list(Sex=c("male"), Pclass=c("1", "3")))
oh$fit(titanic)
head(oh$transform(titanic))


s <- sample(nrow(titanic), nrow(titanic)/2)

p <- pipeline(
  StandardScaler(),
  StandardImputer(method="median"),
  MinMaxScaler(feature_range = c(-1, 1)),
  OnehotEncoder(),
  StandardFilter(predicates=list(function(x) max(x) > 1)))

p$fit(mtcars)
p$transform(mtcars)

q <- p
q$transformers <- head(q$transformers, -1)
q$transform(mtcars)

## Fix reporting of column errors -- requested columns not found in x





p$fit(titanic[-1], y=titanic$Survived)


z <- p$transform(titanic[-1])


dev <- z[s,]
val <- z[-s,]


x <- mtcars

mm <- MinMaxScaler(feature_range=c(-5,5))
mm$fit(mtcars)


res <- mm$fit_transform(mtcars)
mm$inverse_transform(res)

all.equal(mtcars, mm$inverse_transform(res))

ss <- StandardScaler()
ss$fit(mtcars)
res <- ss$fit_transform(mtcars)
ss$inverse_transform(res)
all.equal(mtcars, ss$inverse_transform(res))

scaler$transform(mtcars$mpg)



z <- mtcars$mpg
all.equal(scaler$inverse_transform(scaler$transform(z)), z)

## make mtcars big
for (i in 1:15) mtcars <- rbind(mtcars, mtcars)

p <- pipeline(
  MinMaxScaler(feature_range=c(-1,1)),
  StandardScaler(),
  cols=c("disp", "hp", "mpg"))

z <- p$fit_transform(mtcars)

all.equal(p$inverse_transform(z), mtcars)

p$transform(mtcars)
mtcars$mpg[1:10] <- NA

z <- p$fit_transform(mtcars)
p$inverse_transform(z)


z2 <- p$fit_transform(z1)
z3 <- p$inverse_transform(z2)
all.equal(z1, z3)





