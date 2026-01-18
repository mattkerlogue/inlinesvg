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
  source_note = NULL,
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

- source_note:

  Text to include in a containing `<div>` as a source or reference note
  below the image.

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

Optionally an element `id` can be specified (if not provided one will be
created), if provided will overwrite any existing 'id' attribute encoded
in the SVG object.

A `source_note` can be provided that will be included after the image,
it has the class "svg-source-note" for styling with CSS and an id
starting with "svg-source-note-" and then using the supplied or
generated id.

[`svglite::svglite()`](https://svglite.r-lib.org/reference/svglite.html)
encodes the width and height (in points) of the object into the `<svg>`
tag (in addition to the viewBox declaration), this can cause issues for
responsive scaling of plots. The `dimensions` argument can `"preserve"`
any existing dimensions (the default), `"strip"` the dimensions removing
them from the tag, or `"replace"` them with new dimensions supplied
using the `width`, `height` and `units` arguments.
