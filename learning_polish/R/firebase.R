
manager <- R6::R6Class(
  classname = "słowa",
  public = list(
    initialize = function() {
      self$firebase <- select_categories()
      self$kategorie = data.frame("kategorie" = names(self$firebase)) %>%
        mutate("wiersza" = row_number())
    },
    kategorie = NULL,
    firebase = NULL,
    wybrana_kategoria = function(topic) {
      filter(self$kategorie, wiersza == topic) %>%
        pull(kategorie)
    },
    wybrana_słowa = function(wybrana_kategoria) {
      as.data.frame(
        self$firebase[wybrana_kategoria] %>% unlist() %>% unname(), 
        nm = "words"
      ) %>%
      tidyr::separate(words, c("words", "translation", "date_added"), ":") 
    }
  )
)

#' @title add player
#' @description add a player within a session specified
#' @param session_url character contains url of the session to include player
#' @param user character username digited by player
#' @return character user url created
#' @example add_player("session/-MnToR4E9IHXAnqj6jS_/03ed5d0c", "Felipe")
#' @export
add_words <- function(categories, word) {
  if(word != "") {
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

#' @title select players
#' @description select players within a session specified
#' @param session_url character contains url of the session to include player
#' @return list users
#' @example select_players("session/-MnToR4E9IHXAnqj6jS_/03ed5d0c")
#' @export
select_categories <- function() {
  categories <- content(GET(
    paste0(Sys.getenv("FIREBASE_URL"), "/words/.json")
  ))


  return(categories)
}

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
