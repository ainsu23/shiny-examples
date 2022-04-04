

my_Linked_List <- R6::R6Class(
  classname = "linkedList",
  public = list(
    # Initialize with the first value of the linkedList, .next would be NULL
    initialize = function(value) {
      self$list_pointer <- list(new.env())
      self$list_pointer[[1]]$value <- value
      self$index_head <- 1
      self$index_tail <- 1
      self$list_pointer[[1]]$index_next <- NULL
      self$list_pointer[[1]]$index_prev <- NULL
    },
    list_pointer = NULL,
    index_head = NULL,
    index_tail = NULL,
    # next is an used variable from R.
    get_index = function(index) {
      if (self$index_tail < index) stop("index not created yet!")
      return(self$list_pointer[[index]]$value)
    },
    insert = function(value) {
      self$list_pointer <- self$list_pointer %>%
        append(new.env())
      self$index_tail <- self$index_tail + 1
      self$list_pointer[[self$index_tail]]$index_prev <-
        self$list_pointer[[self$index_tail - 1]]
      self$list_pointer[[self$index_tail - 1]]$index_next <-
        self$list_pointer[[self$index_tail]]
      self$list_pointer[[self$index_tail]]$value <- value
      self$list_pointer[[self$index_tail]]$index_next <- NULL
      return(self$list_pointer)
    }
  )
)

complete_linkedList <- function(word) {
  linkedlist <- my_Linked_List$new(substr(word, 1, 1))
  purrr::map(
    .x = 2:nchar(word),
    .f = function(.x) {
      linkedlist$insert(substr(word, .x, .x))
    }
  )
  return(linkedlist)
}

change_color <- function(LinkedList, .prev, position, .next, letter) {
  letter_actual <- identical(
    LinkedList$list_pointer[[position]]$value,
    letter
  )
  letter_prev <- identical(
    LinkedList$list_pointer[[position]]$index_prev$value,
    .prev
  )
  letter_next <- identical(
    LinkedList$list_pointer[[position]]$index_next$value,
    .next
  )

  color <- case_when(
    !letter_actual ~ "red",
    letter_actual & (!letter_prev | !letter_next) ~ "#b1b100",
    TRUE ~ "green"
  )
  return(color)
}
