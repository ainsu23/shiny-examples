library(dplyr)

# Creación de objeto R6 con el fin de contener información y operaciones en un
# sólo objeto
# Object R6 created to keep information and make operations within one object
manager <- R6::R6Class(
  classname = "słowa",
  public = list(
    initialize = function() {
      private$firebase <- select_categories()
      self$kategorie <- data.frame("kategorie" = names(private$firebase)) %>%
        mutate("wiersza" = row_number())
    },
    #' @field category stored in firebase
    kategorie = NULL,
    #' @method wybrana_kategoria return category selected
    wybrana_kategoria = function(topic) {
      filter(self$kategorie, wiersza == topic) %>%
        pull(kategorie)
    },
    #' @methodwybrana_słowa returns table with words of the category selected
    wybrana_słowa = function(wybrana_kategoria) {
      as.data.frame(
        private$firebase[wybrana_kategoria] %>% unlist() %>% unname(),
        nm = "words"
      ) %>%
        tidyr::separate(words, c("words", "translation", "date_added"), ":")
    }
  ),
  private = list(
    #' @field firebase contains all information stored in firebase
    firebase = NULL
  )
)

words_table <- function(categories) {
  return(data.frame(words = select_words(categories)) %>%
    separate(words, c("words", "translation", "date_added"), ":")) 
}

#' @title add words 
#' @description add a word within a session specified
#' @param session_url character contains url of the session to include word 
#' @example add_words("animals", "kot: ")
#' @export
add_words <- function(categories, word) {
  if (word != "") {
    words <- select_words(categories)
    body <- toJSON(c(words, word),
      pretty = TRUE
    )

    response <- PUT(
      paste0(Sys.getenv("FIREBASE_URL"), "/words/", categories, ".json"),
      body = body
    )
  }
}

#' @title select words
#' @description select words within a session specified
#' @return list words
#' @example select_words("animals")
#' @export
select_words <- function(categories) {
  words <- content(GET(
    paste0(Sys.getenv("FIREBASE_URL"), "/words/", categories, ".json")
  )) %>%
    purrr::flatten() %>%
    unlist()

  return(words)
}

#' @title select categories 
#' @description select categories within a session specified
#' @return list categories 
#' @example select_categories()
#' @export
select_categories <- function() {
  categories <- content(GET(
    paste0(Sys.getenv("FIREBASE_URL"), "/words/.json")
  ))


  return(categories)
}

#' @title delete words
#' @description Deletes as many words as selects
#' @param categories category where the word would be deleted
#' @param word word to be deleted
#' @export
delete_words <- function(categories, word) {
  words_delete <- purrr::map(
    .x = stringr::str_to_lower(word),
    .f = function(.x) {
      content(GET(
        paste0(Sys.getenv("FIREBASE_URL"), "/words/", categories, ".json")
      )) %>%
        stringi::stri_trans_tolower(.) %>%
        unique() %>%
        stringr::str_starts(.x) %>%
        which() - 1
    }
  )

  purrr::map(
    .x = words_delete,
    .f = function(.x) {
      DELETE(
        paste0(
          Sys.getenv("FIREBASE_URL"), "words/", categories, "/", .x, ".json"
        )
      )
    }
  )
}
