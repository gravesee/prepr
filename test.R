## Create a
z1 <- rpois(1e5, 4)

scaler <- StandardScaler()

scaler$fit(z)
scaler$transform(z)
all.equal(scaler$inverse_transform(scaler$transform(z)), z)

## chain together in a pipeline
p <- pipeline(
  StandardScaler(),
  MinMaxScaler(feature_range=c(-1, 1))
)


z2 <- p$fit_transform(z1)
z3 <- p$inverse_transform(z2)
all.equal(z1, z3)

