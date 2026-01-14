# inlinesvg

[inlinesvg](https://mattkerlogue.github.io/inlinesvg/) is a package that
makes it easy to include plots (and other content) as inline SVG
elements in Quarto and R Markdown documents.

## Installation

You can install the development version of inlinesvg from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("mattkerlogue/inlinesvg")
```

## Usage

The
[`inline_svg_plot()`](https://mattkerlogue.github.io/inlinesvg/reference/plot.md)
function allows for the insertion of plots, such as native
[`plot()`](https://mattkerlogue.github.io/inlinesvg/reference/plot.md)
or
[`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
content, as inline SVG within Quarto or R Markdown HTML formats, and
allowing for the provision of ARIA compliant alt text. It is powered by
two separate functions:
[`svg_plot()`](https://mattkerlogue.github.io/inlinesvg/reference/plot.md)
for rendering the plot and
[`inline_svg_file()`](https://mattkerlogue.github.io/inlinesvg/reference/inline_svg_file.md)
to insert the SVG content.

[`svg_plot()`](https://mattkerlogue.github.io/inlinesvg/reference/plot.md)
provides an alternative mechanism for saving plots as SVG files compared
to
[`ggplot2::ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html)
or turning a the graphics device on and off for
[`base::plot()`](https://rdrr.io/r/base/plot.html).
[`inline_svg_file()`](https://mattkerlogue.github.io/inlinesvg/reference/inline_svg_file.md)
provides a generalised method for inserting the content of SVG files
into Quarto and R Markdown based HTML output.

## Motivation

This package is intended for use with [Quarto](https://www.quarto.org)
or [R Markdown](https://rmarkdown.rstudio.com), and specifically HTML
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
[inlinesvg](https://mattkerlogue.github.io/inlinesvg/) package provides
an alternative approach by inserting SVG content directly into the HTML
tree of a document.

While support for alt text has been added to
[ggplot2](https://ggplot2.tidyverse.org),
[svglite](https://svglite.r-lib.org) does not currently support alt
text.
[`inline_svg_plot()`](https://mattkerlogue.github.io/inlinesvg/reference/plot.md)
and
[`inline_svg_file()`](https://mattkerlogue.github.io/inlinesvg/reference/inline_svg_file.md)
enable the incorporation of ARIA compliant short and long form alt text,
through [`<title>` and `<desc>`
tags](https://developer.mozilla.org/en-US/docs/Web/SVG/Guides/SVG_in_HTML#best_practices).
