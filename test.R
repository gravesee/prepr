## Create a
z1 <- rpois(1e5, 4)

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

