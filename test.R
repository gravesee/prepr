## Create a
z1 <- rpois(1e5, 4)

x <- mtcars

mm <- MinMaxScaler(feature_range=c(-5,5))
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

p <- pipeline(
  MinMaxScaler(feature_range=c(-1, 1)),
  StandardScaler(),
  StandardImputer(value=100)
)

mtcars$mpg[1:10] <- NA

p$fit_transform(mtcars)

z2 <- p$fit_transform(z1)
z3 <- p$inverse_transform(z2)
all.equal(z1, z3)

