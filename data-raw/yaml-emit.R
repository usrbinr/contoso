## A small YAML emitter for data-dict.yaml files.
##
## yaml::as.yaml() round-trips correctly but produces a file nobody wants to
## read: no block scalars, everything quoted. These dictionaries ship in the
## package and people read them, so emit the same shape as the hand-written
## inst/extdata/data-dict.yaml -- folded block scalars for prose, flow lists
## for values, ranges and examples.

# Does this string need quoting in a YAML flow context?
needs_quote <- function(x) {
  is.na(x) | x == "" |
    grepl("^[-+.0-9]", x) |
    grepl("^(true|false|null|yes|no|on|off|~)$", x, ignore.case = TRUE) |
    grepl("[][,{}:#&*!|>'\"%@`]", x, perl = TRUE) |
    grepl("^\\s|\\s$", x)
}

scalar <- function(x) {
  if (inherits(x, "Date")) return(format(x, "%Y-%m-%d"))
  if (is.logical(x))       return(tolower(as.character(x)))
  if (is.numeric(x)) {
    return(format(x, scientific = FALSE, trim = TRUE, digits = 15))
  }
  x <- as.character(x)
  ifelse(needs_quote(x), paste0("'", gsub("'", "''", x), "'"), x)
}

flow <- function(v) paste0("[", paste(purrr::map_chr(v, scalar), collapse = ", "), "]")

# Wrap prose to fit the file's width once indented.
fold <- function(text, indent) {
  pad <- strrep(" ", indent)
  strsplit(text, "\n", fixed = TRUE)[[1]] |>
    purrr::map(\(para) {
      if (!nzchar(trimws(para))) return("")
      strwrap(para, width = 79 - indent)
    }) |>
    unlist() |>
    (\(l) paste0(ifelse(nzchar(l), paste0(pad, l), "")))()
}

# `|` keeps the line structure of markdown; `>` folds a plain paragraph.
prose <- function(key, text, indent) {
  pad <- strrep(" ", indent)
  literal <- grepl("\n\n", text, fixed = TRUE) || grepl("^#", text)
  c(paste0(pad, key, ": ", if (literal) "|" else ">"),
    fold(text, indent + 2))
}

emit_constraints <- function(cons, indent) {
  pad <- strrep(" ", indent)
  if (all(purrr::map_lgl(cons, is.character))) {
    return(paste0(pad, "constraints: ", flow(unlist(cons))))
  }
  c(paste0(pad, "constraints:"),
    cons |> purrr::map(\(k) {
      if (is.character(k)) return(paste0(pad, "  - ", scalar(k)))
      out <- paste0(pad, "  - assert: ", k$assert)
      if (!is.null(k$description)) {
        desc <- trimws(k$description)
        # Short one-liners read better inline, which is how the hand-written
        # dictionary writes them; only fold when the text actually needs it.
        out <- c(out, if (!grepl("\n", desc) && nchar(desc) + indent + 17 <= 79) {
          paste0(pad, "    description: ", desc)
        } else {
          prose("description", desc, indent + 4)
        })
      }
      out
    }) |> unlist())
}

emit_column <- function(col, indent = 6) {
  pad <- strrep(" ", indent)
  out <- paste0(pad, "- name: ", scalar(col$name))
  f   <- indent + 2
  fpad <- strrep(" ", f)

  if (!is.null(col$label))  out <- c(out, paste0(fpad, "label: ", scalar(col$label)))
  if (!is.null(col$type))   out <- c(out, paste0(fpad, "type: ", col$type))
  if (!is.null(col$values)) out <- c(out, paste0(fpad, "values: ", flow(col$values)))
  if (!is.null(col$range))  out <- c(out, paste0(fpad, "range: ", flow(col$range)))
  if (!is.null(col$constraints)) out <- c(out, emit_constraints(col$constraints, f))
  if (!is.null(col$description)) out <- c(out, prose("description", col$description, f))
  if (!is.null(col$details))     out <- c(out, prose("details", col$details, f))
  if (!is.null(col$units))       out <- c(out, paste0(fpad, "units: ", scalar(col$units)))
  if (!is.null(col$display))     out <- c(out, paste0(fpad, "display: ", col$display))
  if (!is.null(col$examples))    out <- c(out, paste0(fpad, "examples: ", flow(col$examples)))
  out
}

emit_table <- function(t) {
  out <- paste0("  - name: ", scalar(t$name))
  if (!is.null(t$description)) out <- c(out, prose("description", t$description, 4))
  if (!is.null(t$details))     out <- c(out, prose("details", t$details, 4))
  out <- c(out, "    source:", paste0("      parquet: ", t$source$parquet))
  if (!is.null(t$origin))      out <- c(out, paste0("    origin: ", t$origin))
  if (!is.null(t$constraints)) out <- c(out, emit_constraints(t$constraints, 4))
  c(out, "    columns:", t$columns |> purrr::map(emit_column) |> unlist())
}

emit_dict <- function(d) {
  out <- c(
    paste0("$version: ", d[["$version"]]),
    paste0("$learn_more: ", d[["$learn_more"]]),
    "",
    paste0("name: ", scalar(d$name)),
    prose("description", d$description, 0),
    "",
    prose("details", d$details, 0),
    ""
  )
  if (!is.null(d$origin))  out <- c(out, paste0("origin: ", d$origin), "")
  if (!is.null(d$version)) {
    out <- c(out, "version:", paste0("  ", names(d$version), ": ", unlist(d$version)), "")
  }

  out <- c(out, "tables:",
           d$tables |> purrr::map(\(t) c(emit_table(t), "")) |> unlist())

  out <- c(out, "relationships:",
           d$relationships |> purrr::map(\(r) {
             o <- c(paste0("  - join: ", r$join),
                    paste0("    cardinality: ", r$cardinality))
             if (!is.null(r$conflicts)) o <- c(o, paste0("    conflicts: ", flow(r$conflicts)))
             if (!is.null(r$description)) {
               o <- c(o, prose("description", trimws(r$description), 4))
             }
             c(o, "")
           }) |> unlist())

  out <- c(out, "glossary:",
           names(d$glossary) |> purrr::map(\(term) {
             c(prose(scalar(term), trimws(d$glossary[[term]]), 2), "")
           }) |> unlist())

  out
}
