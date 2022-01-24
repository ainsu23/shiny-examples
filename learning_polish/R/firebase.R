#' @title add player
#' @description add a player within a session specified
#' @param session_url character contains url of the session to include player
#' @param user character username digited by player
#' @return character user url created
#' @example add_player("session/-MnToR4E9IHXAnqj6jS_/03ed5d0c", "Felipe")
#' @export
add_words <- function(categories, word) {
  words <- select_words(categories)
  body <- toJSON(c(words, word),
    pretty = TRUE
  )


  response <- PUT(
    paste0(Sys.getenv("FIREBASE_URL"), "/words/", categories, ".json"),
    body = body
  )
}

#' @title select players
#' @description select players within a session specified
#' @param session_url character contains url of the session to include player
#' @return list users
#' @example select_players("session/-MnToR4E9IHXAnqj6jS_/03ed5d0c")
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
