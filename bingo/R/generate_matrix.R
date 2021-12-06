
generate_matrix <- function() {
  card <- tibble::tibble(
    "B" = sample(1:15, 5),
    "I" = sample(16:30, 5),
    "N" = sample(31:45, 5),
    "G" = sample(46:60, 5),
    "O" = sample(61:75, 5)
  )
  return(card)
}

update_card <- function(.data, .letter, number) {
  .data <- .data %>%
    mutate({{ .letter }} :=
      ifelse(
        {{ .letter }} == {{ number }}, 0,
        {{ .letter }}
      ))
  return(.data)
}
