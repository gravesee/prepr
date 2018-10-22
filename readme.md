Preparation R
-------------

This package is used to temporarily relieve swelling, burning, pain, and
itching caused by data preparation. Heavily influenced by sklearn
preprocessing module. As such it aims to implement the Transformer API
and allow for pipelines that can be saved and applied to new datasets.

It will eventually include methods for outputting to PMML or json to
assist with productionalizing data preparation steps.

    ## create a onehot encoder
    oh <- OnehotEncoder(levels=list(Sex="male", Pclass=c("1", "3")))

    ## fit the scaler using a data.frame
    oh$fit(titanic)

    ## transform each column of data.frame 
    knitr::kable(head(oh$transform(head(titanic))))

<table>
<thead>
<tr class="header">
<th align="right">Survived</th>
<th align="right">Age</th>
<th align="right">SibSp</th>
<th align="right">Parch</th>
<th align="right">Fare</th>
<th align="left">Embarked</th>
<th align="right">Sex=male</th>
<th align="right">Pclass=1</th>
<th align="right">Pclass=3</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="right">0</td>
<td align="right">22</td>
<td align="right">1</td>
<td align="right">0</td>
<td align="right">7.2500</td>
<td align="left">S</td>
<td align="right">1</td>
<td align="right">0</td>
<td align="right">1</td>
</tr>
<tr class="even">
<td align="right">1</td>
<td align="right">38</td>
<td align="right">1</td>
<td align="right">0</td>
<td align="right">71.2833</td>
<td align="left">C</td>
<td align="right">0</td>
<td align="right">1</td>
<td align="right">0</td>
</tr>
<tr class="odd">
<td align="right">1</td>
<td align="right">26</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="right">7.9250</td>
<td align="left">S</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="right">1</td>
</tr>
<tr class="even">
<td align="right">1</td>
<td align="right">35</td>
<td align="right">1</td>
<td align="right">0</td>
<td align="right">53.1000</td>
<td align="left">S</td>
<td align="right">0</td>
<td align="right">1</td>
<td align="right">0</td>
</tr>
<tr class="odd">
<td align="right">0</td>
<td align="right">35</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="right">8.0500</td>
<td align="left">S</td>
<td align="right">1</td>
<td align="right">0</td>
<td align="right">1</td>
</tr>
<tr class="even">
<td align="right">0</td>
<td align="right">NA</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="right">8.4583</td>
<td align="left">Q</td>
<td align="right">1</td>
<td align="right">0</td>
<td align="right">1</td>
</tr>
</tbody>
</table>

Specify Subset of Columns
-------------------------

All transformers take a `cols` argument. It can be a character vector of
column name which limits the transformer operations to just those
columns. Optionally, "factor" or "numeric" can be specified to limit
opertions to just columns of those types. Most transformers have a
default value for the `cols` argument that makes sense for the
operation.

    mm <- MinMaxScaler(feature_range=c(-1, 1), cols=c("disp", "hp", "wt"))
    z <- mm$fit_transform(mtcars)

    ## only specified columns are transformed
    knitr::kable(sapply(z, range))

<table>
<thead>
<tr class="header">
<th align="right">mpg</th>
<th align="right">cyl</th>
<th align="right">disp</th>
<th align="right">hp</th>
<th align="right">drat</th>
<th align="right">wt</th>
<th align="right">qsec</th>
<th align="right">vs</th>
<th align="right">am</th>
<th align="right">gear</th>
<th align="right">carb</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="right">10.4</td>
<td align="right">4</td>
<td align="right">-1</td>
<td align="right">-1</td>
<td align="right">2.76</td>
<td align="right">-1</td>
<td align="right">14.5</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="right">3</td>
<td align="right">1</td>
</tr>
<tr class="even">
<td align="right">33.9</td>
<td align="right">8</td>
<td align="right">1</td>
<td align="right">1</td>
<td align="right">4.93</td>
<td align="right">1</td>
<td align="right">22.9</td>
<td align="right">1</td>
<td align="right">1</td>
<td align="right">5</td>
<td align="right">8</td>
</tr>
</tbody>
</table>

### Pipelines

Pipelines simply chain together transformers in a list. They implement
the Transformer API as well and support the same methods. Columns can
also have an optional `cols` argument that will limit all pipeline
operations to the columns specified.

    ## chain together in a pipeline
    p <- pipeline(
      MinMaxScaler(feature_range=c(-1, 1)),
      StandardImputer(method="median"),
      OnehotEncoder(levels=list(Sex="male", Pclass=c("1", "3"))),
      OnehotEncoder()) ## The rest

    z <- p$fit_transform(titanic[-1])

    knitr::kable(head(z))

<table>
<thead>
<tr class="header">
<th align="right">Age</th>
<th align="right">SibSp</th>
<th align="right">Parch</th>
<th align="right">Fare</th>
<th align="right">Sex=male</th>
<th align="right">Pclass=1</th>
<th align="right">Pclass=3</th>
<th align="right">Embarked=C</th>
<th align="right">Embarked=Q</th>
<th align="right">Embarked=S</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="right">-0.4576527</td>
<td align="right">-0.75</td>
<td align="right">-1</td>
<td align="right">-0.9716979</td>
<td align="right">1</td>
<td align="right">0</td>
<td align="right">1</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="right">1</td>
</tr>
<tr class="even">
<td align="right">-0.0555416</td>
<td align="right">-0.75</td>
<td align="right">-1</td>
<td align="right">-0.7217285</td>
<td align="right">0</td>
<td align="right">1</td>
<td align="right">0</td>
<td align="right">1</td>
<td align="right">0</td>
<td align="right">0</td>
</tr>
<tr class="odd">
<td align="right">-0.3571249</td>
<td align="right">-1.00</td>
<td align="right">-1</td>
<td align="right">-0.9690629</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="right">1</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="right">1</td>
</tr>
<tr class="even">
<td align="right">-0.1309374</td>
<td align="right">-0.75</td>
<td align="right">-1</td>
<td align="right">-0.7927114</td>
<td align="right">0</td>
<td align="right">1</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="right">1</td>
</tr>
<tr class="odd">
<td align="right">-0.1309374</td>
<td align="right">-1.00</td>
<td align="right">-1</td>
<td align="right">-0.9685749</td>
<td align="right">1</td>
<td align="right">0</td>
<td align="right">1</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="right">1</td>
</tr>
<tr class="even">
<td align="right">-0.3068610</td>
<td align="right">-1.00</td>
<td align="right">-1</td>
<td align="right">-0.9669810</td>
<td align="right">1</td>
<td align="right">0</td>
<td align="right">1</td>
<td align="right">0</td>
<td align="right">1</td>
<td align="right">0</td>
</tr>
</tbody>
</table>

Note that the order of the pipeline transformers is important. If you
pass numeric transformers after onehot encoders for example, the onehot
output will be transformed as it is now numeric. As of yet there is no
mechanism for preventing this from happening or warning the user.
