# Insert SVG file as inline content

Inserts the content of the SVG file as inline SVG content, i.e. into the
body of the resulting HTML.

## Usage

``` r
inline_svg_file(
  path,
  id = NULL,
  role = NULL,
  alt_title = NULL,
  alt_description = NULL,
  strip_ns = TRUE,
  dimensions = c("preserve", "strip", "replace"),
  width = NULL,
  height = NULL,
  units = NULL
)
```

## Arguments

- path:

  Path to the SVG file

- id:

  An id value for the SVG element within the HTML document (optional)

- role:

  The ARIA role for the SVG element (optional)

- alt_title:

  A short title for assistive technology users (optional)

- alt_description:

  A longer description for assistive technology users (optional)

- strip_ns:

  Whether to remove the XML DTD

- dimensions:

  Whether to 'preserve' dimensions defined in the SVG tag, to 'strip'
  them or 'replace' them with provided values

- width:

  The width of the SVG element (optional)

- height:

  The height of the SVG element (optional)

- units:

  The units for width and height (optional)

## Value

An
[`htmltools::HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
object

## Details

In Quarto and R Markdown documents inserting SVG images via standard
image markdown (e.g. `![alt_text](img.svg)`) or HTML `<img>` tags
results in an SVG that is rendered as an image and cannot be interacted
with by the user (e.g. selecting text), nor can elements be modified by
CSS. `inline_svg_file()` takes the content of an SVG file and inserts it
as inline SVG content within the body of the rendered HTML document.

Optionally an element 'id' can be specified (if not provided one will be
created), and any dimensions specified in the `<svg>` tag can either be
preserved, dropped or replaced. If an id attribute is detected in the
existing `<svg>` tag then this argument will be ignored.
