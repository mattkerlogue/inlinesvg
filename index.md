# inlineSVG

[inlineSVG](https://mattkerlogue.github.io/inlinesvg/) is a package that
makes it easy to include plots (and other content) as inline SVG
elements in Quarto and R Markdown documents.

## Installation

You can install the development version of inlineSVG from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("mattkerlogue/inlinesvg")
```

## Usage

The
[`inline_svg_plot()`](https://mattkerlogue.github.io/inlinesvg/reference/plot.md)
function allows for the insertion of plots, either native
[`plot()`](https://mattkerlogue.github.io/inlinesvg/reference/plot.md)
or
[`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
content, as inline SVG within Quarto or R Markdown HTML formats, and
allowing for the provision of ARIA compliant alt text.

[`svg_plot()`](https://mattkerlogue.github.io/inlinesvg/reference/plot.md)
provides an alternative mechanism for saving plots as SVG files compared
to
[`ggplot2::ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html)
or more complex methods for
[`base::plot()`](https://rdrr.io/r/base/plot.html).
[`inline_svg_file()`](https://mattkerlogue.github.io/inlinesvg/reference/inline_svg_file.md)
provides a generalised method for inserting the content of SVG files
into Quarto and R Markdown based HTML output.

## Motivation

This package is intended for use with [Quarto](https://www.quarto.org)
or [R Markdown](https://rmarkdown.rstudio.com), anf specifically HTML
output formats from both of these.

There are two main methods for producing SVG content from R:

- the native
  [`grDevices::svg()`](https://rdrr.io/r/grDevices/cairo.html) (and
  related `Cairo::CairoSVG()`) device based on the [Cairo graphics
  library](https://www.cairographics.org), or
- the
  [`svglite::svglite()`](https://svglite.r-lib.org/reference/svglite.html)
  device.

When rendering plots in Quarto (and R Markdown) for HTML using a vector
graphics output such as SVG is better than raster output such as JPEG or
PNG since vector graphics can scale with changes in resolution. The
standard approach to including graphics within Quarto or R Markdown
content, either in raw format (e.g. `![alt](file)`) or via {knitr} cells
results in the SVG content being rendered via an HTML `<img>` tag.

Using the `<img>` tag results in the content being treated as if it were
a raster-based image format such as JPEG or PNG. While web browsers will
scale SVG content within an `<img>` tag, the internal components of the
SVG are inaccessible to the browser engine meaning that it cannot be
styled via CSS or interacted with (e.g. text cannot be selected). The
`{inlinesvg}` package provides an alternative approach by inserting SVG
content directly into the HTML tree of a document.
