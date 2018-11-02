Preparation R
-------------

This package is used to temporarily relieve swelling, burning, pain, and
itching caused by data preparation. Heavily influenced by sklearn
preprocessing module. As such it aims to implement the Transformer API
and allow for pipelines that can be saved and applied to new datasets.

### Isn’t there already a package that does this?

Yes, and it’s pretty comprehensive. Check out the `recipes` package
here:
<a href="https://tidymodels.github.io/recipes/" class="uri">https://tidymodels.github.io/recipes/</a>
. So why reinvent the wheel? Well I am not a huge fan of the tidyverse.
I like that it turns new users on to R and the folks at RStudio have
done so much for the R community. The tidyverse is very opinionated and
still evolving. I prefer to stick to base R when I can and I especially
like understanding how things work under the hood. Hence this package.

Prep Functions
--------------

Processing pipelines are nothing new. So it’s no suprise that this
package follows a similar approach. You can create a pipeline explicitly
using the `pipeline` function or in a `maggritr` style by using the
pipeline operator, `%|>%`, to pipe multiple prep functions into each
other.

    data(iris)

    p1 <- pipeline(
      prep_minmax(~.-Species),
      prep_onehot(~sel_factor()),
      sink_matrix()
    )

    p2 <-
      prep_minmax(~.-Species) %|>%
      prep_onehot(~sel_factor()) %|>%
      sink_matrix()

    all.equal(p1, p2)

    ## [1] TRUE

    ## print out
    p1

    ## [ Pipeline ] [isfit:  no ]
    ## |--[ MinMaxScaler ] [isfit:  no ]
    ## |--[ OnehotEncoder ] [isfit:  no ]
    ## |--[ Sink ] [isfit:  no ]

Fitting
-------

The purpose of creating these pipelines is to fit them to data and save
them to apply on different datasets. The fit method is used to fit a
pipeline. It works by fitting each transform in sequence and passing the
transformed data down the pipe. Once it has been trained, the `isfit`
member will be set to `TRUE`

    p1$fit(iris)
    p1

    ## [ Pipeline ] [isfit:  yes ]
    ## |--[ MinMaxScaler ] [isfit:  yes ]
    ## |--[ OnehotEncoder ] [isfit:  yes ]
    ## |--[ Sink ] [isfit:  yes ]

Transforming
------------

Once a pipeline has been fit, the transform method can be called and
passed a new dataset. The settings saved during the training process
will be applied to the new dataset ensuring a reproducible workflow with
little micromanagement.

    z <- p1$transform(iris)
    knitr::kable(head(z), digits = 2)

<table>
<thead>
<tr class="header">
<th style="text-align: right;">Sepal.Length</th>
<th style="text-align: right;">Sepal.Width</th>
<th style="text-align: right;">Petal.Length</th>
<th style="text-align: right;">Petal.Width</th>
<th style="text-align: right;">Species=setosa</th>
<th style="text-align: right;">Species=versicolor</th>
<th style="text-align: right;">Species=virginica</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: right;">-0.56</td>
<td style="text-align: right;">0.25</td>
<td style="text-align: right;">-0.86</td>
<td style="text-align: right;">-0.92</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="even">
<td style="text-align: right;">-0.67</td>
<td style="text-align: right;">-0.17</td>
<td style="text-align: right;">-0.86</td>
<td style="text-align: right;">-0.92</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="odd">
<td style="text-align: right;">-0.78</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">-0.90</td>
<td style="text-align: right;">-0.92</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="even">
<td style="text-align: right;">-0.83</td>
<td style="text-align: right;">-0.08</td>
<td style="text-align: right;">-0.83</td>
<td style="text-align: right;">-0.92</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="odd">
<td style="text-align: right;">-0.61</td>
<td style="text-align: right;">0.33</td>
<td style="text-align: right;">-0.86</td>
<td style="text-align: right;">-0.92</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="even">
<td style="text-align: right;">-0.39</td>
<td style="text-align: right;">0.58</td>
<td style="text-align: right;">-0.76</td>
<td style="text-align: right;">-0.75</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
</tbody>
</table>
