# generic numeric value check
check_numeric_scalar <- function(x, caller) {
  if (!is.numeric(x) || length(x) != 1) {
    cli::cli_abort(c(
      "x" = "{.arg {caller}} must be a numeric vector of length 1"
    ))
  }
}

check_character_scalar <- function(x, caller) {
  if (!is.character(x) || length(x) != 1) {
    cli::cli_abort(c(
      "x" = "{.arg {caller}} must be a character vector of length 1"
    ))
  }
}

# check for file path
check_path_exists <- function(path) {
  check_character_scalar(path, "path")

  if (!file.exists(path)) {
    cli::cli_abort(
      c(
        "x" = "Supplied {.arg path} does not exist",
        "i" = "{.file {path}}"
      )
    )
  }
}

# check whether file can be overwritten
check_path_overwrite <- function(path, overwrite) {
  check_character_scalar(path, "path")

  if (file.exists(path) && !overwrite) {
    cli::cli_abort(
      c(
        "x" = "Supplied {.arg path} exists and {.arg overwrite} not permitted",
        "i" = "{.file {file}}"
      )
    )
  }
}

# check dimensions provided are valid
check_dims <- function(width, height, units) {
  if (missing(width)) {
    cli::cli_abort(c(
      "x" = "{.arg width} is required"
    ))
  }

  check_numeric_scalar(width, "width")

  if (missing(height)) {
    cli::cli_abort(c(
      "x" = "{.arg height} is required"
    ))
  }

  check_numeric_scalar(height, "height")

  if (missing(units)) {
    cli::cli_abort(c(
      "x" = "{.arg units} is required"
    ))
  }

  check_units(units)
}

# check if units provided are valid
check_units <- function(units) {
  check_character_scalar(units, "units")

  if (!(units %in% units_list())) {
    cli::cli_abort(c(
      "x" = "{.arg units} must be a valid CSS length unit",
      "i" = "See {.url https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/length}"
    ))
  }
}

check_alt_text <- function(text, what = c("alt_title", "alt_description")) {
  what = match.arg(what)
  check_character_scalar(text, what)

  if (what == "alt_title" & nchar(text) > 150) {
    cli::cli_warn(c(
      "!" = "{.arg alt_title} should be 150 characters or less",
      "i" = "{.arg alt_title} is {nchar(text)} characters long",
      "i" = "For long-form alt text consider using {.arg alt_description}"
    ))
  }
}

check_source_note <- function(text) {
  check_character_scalar(text, "source_note")
}

# list of valid CSS units
units_list <- function() {
  # CSS absolutes based on https://www.w3.org/TR/CSS22/syndata.html#length-units
  c(
    "in",
    "cm",
    "mm",
    "pc",
    "pt",
    "px"
  )
}

# convert units to inches
convert_to_in <- function(size, units, .dim) {
  check_numeric_scalar(size, .dim)
  check_units(units)
  size_in <- NULL
  if (units == "in") {
    size_in <- size
  } else if (units == "px") {
    size_in <- size / 96
  } else if (units == "pt") {
    size_in <- size / 72
  } else if (units == "pc") {
    size_in <- size / 6
  } else if (units == "cm") {
    size_in <- size / 2.54
  } else if (units == "mm") {
    size_in <- size / 254
  }
}
