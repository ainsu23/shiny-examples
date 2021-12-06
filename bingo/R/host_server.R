
# owner user server
generate_figures <- function(columns, rows) {
  show_card <- tibble::tibble(
    "B" = rep(0, 5),
    "I" = rep(0, 5),
    "N" = rep(0, 5),
    "G" = rep(0, 5),
    "O" = rep(0, 5)
  )
  show_card[rows, columns] <- 1

  .letters <- show_card %>%
    colSums() %>%
    purrr::keep(function(x) x != 0) %>%
    names()

  return(.letters)
}

generate_numbers <- function(.letters, numbers_came_out = 0) {
  numbers <- tibble::tibble(
    "B" = 1:15,
    "I" = 16:30,
    "N" = 31:45,
    "G" = 46:60,
    "O" = 61:75
  ) %>%
    select(all_of(.letters))

  if (sum(numbers) == 0) stop("End game")
  .column <- sample(numbers, 1)
  .number <- .column %>%
    filter(!(!!rlang::sym(colnames(.column)) %in% numbers_came_out)) %>%
    unlist() %>%
    sample(1)

  return(list(letter = colnames(.column), number = .number))
}
