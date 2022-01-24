join_words <- function(word, translation) {
  word_translated <- glue("{word}: {translation}: {lubridate::today()}")
  return(word_translated)
}
