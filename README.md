
<!-- README.md is generated from README.Rmd. Please edit that file -->

# inlinesvg

<!-- badges: start -->

<!-- badges: end -->

`{inlinesvg}` is a package that makes it easy to include plots (and
other content) as inline SVG elements in Quarto and R Markdown
documents.

## Installation

You can install the development version of inlinesvg from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("mattkerlogue/inlinesvg")
```

## Usage

The `inline_svg_plot()` function allows for the insertion of plots,
either native `plot()` or `ggplot2::ggplot()` content, as inline SVG
within Quarto or R Markdown HTML formats, and allowing for the provision
of ARIA compliant alt text.

`svg_plot()` provides an alternative mechanism for saving plots as SVG
files compared to `ggplot2::ggsave()` or more complex methods for
`base::plot()`. `inline_svg_file()` provides a generalised method for
inserting the content of SVG files into Quarto and R Markdown based HTML
output.

## Motivation

This package is intended for use with [Quarto](https://www.quarto.org)
or [R Markdown](https://rmarkdown.rstudio.com), anf specifically HTML
output formats from both of these.

There are two main methods for producing SVG content from R:

- the native `grDevices::svg()` (and related `Cairo::CairoSVG()`) device
  based on the [Cairo graphics library](https://www.cairographics.org),
  or
- the `svglite::svglite()` device.

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
