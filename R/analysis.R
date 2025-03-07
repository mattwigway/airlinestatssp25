#' Find busiest air routes.
#'
#' This finds the busiest (bidirectional) air routes in the country.
#'
#' @param dataframe data with flight records (disaggregate)
#' @param origcol column identifying origin airport or city
#' @param destcol column identifying destination city or airport
#'
#' @returns sorted list of busiest routes
#'
#' @export
busiest_routes = function (dataframe, origcol, destcol) {
  stopifnot(all(dataframe$Passengers >= 1))
  stopifnot(all(!is.na(dataframe$Passengers)))

  # Now, we can see what the most popular air route is, by summing up the number of
  # passengers carried.
  pairs = group_by(dataframe, {{ origcol }}, {{ destcol }}) %>%
    summarize(Passengers=sum(Passengers), distance_km=first(Distance) * MILES_TO_KILOMETERS)
  arrange(pairs, -Passengers)

  # we see that LAX-JFK (Los Angeles to New York Kennedy) is represented separately
  # from JFK-LAX. We'd like to combine these two. Create airport1 and airport2 fields
  # with the first and second airport in alphabetical order.
  pairs = mutate(
    pairs, location1 = if_else({{ origcol }} < {{ destcol }}, {{ origcol }}, {{ destcol }}),
    location2 = if_else({{ origcol }} < {{ destcol }}, {{ destcol }}, {{ origcol }})
  )

  pairs = group_by(pairs, location1, location2) %>%
    summarize(Passengers=sum(Passengers), distance_km=first(distance_km))

  return(arrange(pairs, -Passengers))
}

#' Find market shares.
#'
#' @param dataframe data with airline tickets
#' @param origcol origin city or airport
#' @param carriercol air carrier
#'
#' @returns data frame of market shares by airport and carrier
#'
#' @export
market_shares = function (dataframe, origcol, carriercol) {
  # Now, we can compute the market shares
  mkt_shares = group_by(dataframe, {{ origcol }}, {{ carriercol }}) %>%
    summarize(Passengers=sum(Passengers)) %>%
    group_by({{ origcol }}) %>%
    mutate(market_share=Passengers/sum(Passengers) * 100, total_passengers=sum(Passengers)) %>%
    ungroup()

  mkt_shares %>% arrange(-market_share) %>% return()
}
