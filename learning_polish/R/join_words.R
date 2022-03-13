

#' @title join words
#' @description join words create one string from word: translation: date
#' @param word word to join
#' @param translation translation to join
#' @return word joined
join_words <- function(word, translation) {
  word_translated <- glue("{word}: {translation}: {lubridate::today()}")
  return(word_translated)
}
