#' Render plots as SVG and insert as inline content
#'
#' A wrapper to `svglite::svglite()` for saving plots as SVG files and
#' inserting as inline_content.
#'
#' `svg_plot()` is a wrapper around the `svglite::svglite()` graphics
#' device that simplifies its use for saving plots. Compared to
#' `svglite::svglite()` users do not need to manually active and deactivate
#' the graphics device, users can also specify width and height in dimensions
#' other than inches.
#'
#' `inline_svg_plot()` combines `svg_plot()` with `inline_svg_file()` to insert
#' the plot as inline SVG content within a Quarto or R Markdown document.
#'
#' Unless otherwise specified the chart is rendered to SVG via a temporary
#' file, this path is returned invisibly from `svg_plot()`. If re-using plots
#' elsewhere it is advised to use an explicit path name and use
#' `inline_svg_file()` to re-insert the SVG content rather than rely on the
#' temporary path provided by `svg_plot()`.
#'
#' An `id` for the inline SVG can be provided for so that it is directly
#' accessible via HTML or CSS (e.g. for linking or styling).
#'
#' @details # Alt text
#' The `alt_title` and `alt_description` allow for the insertion of alt text
#' into the SVG content, `alt_title` is intended for short descriptions and
#' `alt_description` for longer-form descriptions. If the supplied plot is a
#' a `ggplot2::ggplot()` object and no alt text is supplied then the plot
#' object will be inspected for alt text, if the alt text is 150 characters or
#' less it will be used for `alt_title` but if longer it will be used for
#' `alt_description`.
#'
#' @param plot A graphics object to plot.
#' @param path A file path to save the SVG plot to (optional).
#' @param width Width of the output plot.
#' @param height Height of the output plot.
#' @param units Units used for width and height.
#' @param overwrite Should files be overwritten (default is `TRUE`)
#' @param alt_title Short alt text to include in the inline SVG (optional).
#' @param alt_description Long-form alt text to include in the inline SVG
#'   (optional).
#' @param id An id for referencing the SVG within the HTML/CSS (optional)
#' @param explicit_size Whether the inline `<svg>` tag should explicitly
#'   include the dimensions of the plot (default is `FALSE`).
#' @param standalone Whether `svglite::svglite()` should omit the XML DTD
#'   header and namespace info (default is `FALSE`).
#' @param ... Arguments passed on to `svglite::svglite()`.
#'
#' @name plot

#' @rdname plot
#' @export
svg_plot <- function(
  plot,
path = NULL,
  width,
  height,
  units = c("px", "pt", "cm", "mm", "in"),
    overwrite = TRUE,
  standalone = TRUE,
  ...
) {
  units <- rlang::arg_match(units)

  if (is.null(path)) {
    path <- tempfile(fileext = ".svg")
  }

  check_path_overwrite(path, overwrite)

  width_in <- convert_to_in(width, units, .dim = "width")
  height_in <- convert_to_in(height, units, .dim = "height")

  message(path)

  svglite::svglite(
    filename = path,
    width = width_in,
    height = height_in,
    standalone = standalone,
    ...
  )
  grid::grid.draw(plot)
  grDevices::dev.off()

  invisible(path)
}

#' @rdname plot
#' @export
inline_svg_plot <- function(
  plot,
path = NULL,
  width,
  height,
  units = c("px", "pt", "cm", "mm", "in"),
    overwrite = NULL,
  alt_title = NULL,
  alt_description = NULL,
  id = NULL,
  explicit_size = FALSE,
  standalone = FALSE,
  ...
) {
  svg_path <- svg_plot(
    plot = plot,
    width = width,
    height = height,
    units = units,
    path = path,
    overwrite = overwrite,
    standalone = standalone,
    ...
  )

  if (is.null(alt_title) && is.null(alt_description)) {
    if (requireNamespace("ggplot2", quietly = TRUE)) {
      if (ggplot2::is_ggplot(plot)) {
        p_alt <- ggplot2::get_alt_text(plot)
        if (nchar(p_alt) > 150) {
          alt_description <- p_alt
        } else if (p_alt != "") {
          alt_title <- p_alt
        }
      }
    }
  }

  dims <- NULL
  if (explicit_size) {
    dims <- "preserve"
  } else {
    dims <- "strip"
    width <- NULL
    height <- NULL
    units <- NULL
  }

  inline_svg_file(
    path = svg_path,
    id = id,
    role = "img",
    alt_title = alt_title,
    alt_description = alt_description,
    strip_ns = TRUE,
    dimensions = dims,
    width = width,
    height = height,
    units = units
  )
}

#' Insert SVG file as inline content
#'
#' Inserts the content of the SVG file as inline SVG content, i.e. into the
#' body of the resulting HTML.
#'
#' In Quarto and R Markdown documents inserting SVG images via standard image
#' markdown (e.g. `![alt_text](img.svg)`) or HTML `<img>` tags results in an
#' SVG that is rendered as an image and cannot be interacted with by the
#' user (e.g. selecting text), nor can elements be modified by CSS.
#' `inline_svg_file()` takes the content of an SVG file and inserts it as
#' inline SVG content within the body of the rendered HTML document.
#'
#' Optionally an element 'id' can be specified (if not provided one will be
#' created), and any dimensions specified in the `<svg>` tag can either be
#' preserved, dropped or replaced. If an id attribute is detected in the
#' existing `<svg>` tag then this argument will be ignored.
#'
#' @param path Path to the SVG file
#' @param id An id value for the SVG element within the HTML document (optional)
#' @param role The ARIA role for the SVG element (optional)
#' @param alt_title A short title for assistive technology users (optional)
#' @param alt_description A longer description for assistive technology users
#'   (optional)
#' @param strip_ns Whether to remove the XML DTD
#' @param dimensions Whether to 'preserve' dimensions defined in the SVG tag,
#'   to 'strip' them or 'replace' them with provided values
#' @param width The width of the SVG element (optional)
#' @param height The height of the SVG element (optional)
#' @param units The units for width and height (optional)
#'
#' @returns An `htmltools::HTML()` object
#'
#' @export
inline_svg_file <- function(
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
) {
  check_path_exists(path)
  dimensions <- match.arg(dimensions)

  svg_xml <- xml2::read_xml(path)

  # if no id, make an id
  hash_moment <- substr(cli::hash_sha1(Sys.time()), 1, 6)
  if (is.null(id)) {
    id <- paste0("svg-", hash_moment)
  }

  # alt text elements
  alt_elements <- character()

  if (!is.null(alt_title)) {
    alt_title_id <- paste0(id, "-title")
    alt_title_tag <- create_alt_tag("alt_title", alt_title, alt_title_id)
    alt_elements <- c(alt_elements, "title" = alt_title_id)
  }

  if (!is.null(alt_description)) {
    alt_desc_id <- paste0(id, "-desc")
    alt_desc_tag <- create_alt_tag(
      "alt_description",
      alt_description,
      alt_desc_id
    )
    alt_elements <- c(alt_elements, "desc" = alt_desc_id)
  }

  # insert role
  if (!is.null(role)) {
    check_character_scalar(role, "role")
    xml2::xml_set_attr(svg_xml, "role", role)
  }

  # insert id
  xml2::xml_set_attr(svg_xml, "id", id)

  # insert alt
  if (length(alt_elements) == 2) {
    svg_xml |>
      xml2::xml_add_child(alt_title_tag, .where = 0) |>
      xml2::xml_add_sibling(alt_desc_tag)

    xml2::xml_set_attr(svg_xml, "aria-labelledby", paste(unname(alt_elements)))
  } else if (length(alt_elements) == 1) {
    if (names(alt_elements) == "title") {
      svg_xml |>
        xml2::xml_add_child(alt_title_tag, .where = 0)
    } else {
      svg_xml |>
        xml2::xml_add_child(alt_desc_tag, .where = 0)
    }

    xml2::xml_set_attr(svg_xml, "aria-labelledby", paste(unname(alt_elements)))
  }

  # handle dimensions
  if (dimensions == "strip") {
    xml2::xml_set_attr(svg_xml, "width", NULL)
    xml2::xml_set_attr(svg_xml, "height", NULL)
  } else if (dimensions == "replace") {
    check_dims(width, height, units)
    xml2::xml_set_attr(svg_xml, "width", paste0(width, units))
    xml2::xml_set_attr(svg_xml, "height", paste0(height, units))
  }

  if (strip_ns) {
    xml2::xml_ns_strip(svg_xml)
    xml2::xml_set_attr(svg_xml, "xmlns:xlink", NULL)
  }

  # collapse string and insert
  svg_string <- as.character(svg_xml, options = "no_declaration")
  return(htmltools::HTML(svg_string))
}


create_alt_tag <- function(what = c("alt_title", "alt_description"), text, id) {
  what <- match.arg(what)

  check_alt_text(text, what)

  tag <- switch(
    what,
    "alt_title" = "title",
    "alt_description" = "desc"
  )

  xml2::xml_new_root(tag, id = id, text)
}
