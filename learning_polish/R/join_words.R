box::use(
  magrittr[`%>%`],
  glue[glue]
)

#' @export
join_words <- function(word, translation) {
  word_translated <- glue("{word}: {translation}")
  return(word_translated)
}
