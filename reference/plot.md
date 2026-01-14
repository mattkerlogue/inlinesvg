# Render plots as SVG and insert as inline content

A wrapper to
[`svglite::svglite()`](https://svglite.r-lib.org/reference/svglite.html)
for saving plots as SVG files and inserting as inline_content.

## Usage

``` r
svg_plot(
  plot,
  width,
  height,
  units = c("px", "pt", "cm", "mm", "in"),
  path = NULL,
  overwrite = TRUE,
  standalone = TRUE,
  ...
)

inline_svg_plot(
  plot,
  width,
  height,
  units = c("px", "pt", "cm", "mm", "in"),
  path = NULL,
  overwrite = NULL,
  alt_title = NULL,
  alt_description = NULL,
  id = NULL,
  explicit_size = FALSE,
  standalone = FALSE,
  ...
)
```

## Arguments

- plot:

  A graphics object to plot.

- width:

  Width of the output plot.

- height:

  Height of the output plot.

- units:

  Units used for width and height.

- path:

  A file path to save the SVG plot to (optional).

- overwrite:

  Should files be overwritten (default is `TRUE`)

- standalone:

  Whether
  [`svglite::svglite()`](https://svglite.r-lib.org/reference/svglite.html)
  should omit the XML DTD header and namespace info (default is
  `FALSE`).

- ...:

  Arguments passed on to
  [`svglite::svglite()`](https://svglite.r-lib.org/reference/svglite.html).

- alt_title:

  Short alt text to include in the inline SVG (optional).

- alt_description:

  Long-form alt text to include in the inline SVG (optional).

- id:

  An id for referencing the SVG within the HTML/CSS (optional)

- explicit_size:

  Whether the inline `<svg>` tag should explicitly include the
  dimensions of the plot (default is `FALSE`).

## Details

`svg_plot()` is a wrapper around the
[`svglite::svglite()`](https://svglite.r-lib.org/reference/svglite.html)
graphics device that simplifies its use for saving plots. Compared to
[`svglite::svglite()`](https://svglite.r-lib.org/reference/svglite.html)
users do not need to manually active and deactivate the graphics device,
users can also specify width and height in dimensions other than inches.

`inline_svg_plot()` combines `svg_plot()` with
[`inline_svg_file()`](https://mattkerlogue.github.io/inlinesvg/reference/inline_svg_file.md)
to insert the plot as inline SVG content within a Quarto or R Markdown
document.

Unless otherwise specified the chart is rendered to SVG via a temporary
file, this path is returned invisibly from `svg_plot()`. If re-using
plots elsewhere it is advised to use an explicit path name and use
[`inline_svg_file()`](https://mattkerlogue.github.io/inlinesvg/reference/inline_svg_file.md)
to re-insert the SVG content rather than rely on the temporary path
provided by `svg_plot()`.

An `id` for the inline SVG can be provided for so that it is directly
accessible via HTML or CSS (e.g. for linking or styling).

## Alt text

The `alt_title` and `alt_description` allow for the insertion of alt
text into the SVG content, `alt_title` is intended for short
descriptions and `alt_description` for longer-form descriptions. If the
supplied plot is a a
[`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
object and no alt text is supplied then the plot object will be
inspected for alt text, if the alt text is 150 characters or less it
will be used for `alt_title` but if longer it will be used for
`alt_description`.
