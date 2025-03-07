get_data = function () {
  data = dplyr::tibble(
    Origin=rep(c("SFO", "ORD", "DCA", "PHX", "BOS", "RDU"), 20),
    Destination=rep(c("DFW", "MCI", "MIA", "ABQ", "IAH", "SJU"), 20),
    Passengers=rep(1:6, 20),
    Carrier=rep(c("United", "American", "Delta", "Southwest"), 30)
  )
  return(data)
}

test_that("Market shares sum to 1", {
  data = get_data()
  shares = market_shares(data, Origin, Carrier)
  total_shares = group_by(shares, Origin) %>% summarize(overall=sum(market_share))
  # six airports, so six shares
  expect_equal(total_shares$overall, rep(1, 6))
})

test_that("Error when passengers column missing", {
  data = get_data() %>% dplyr::select(-Passengers)
  expect_error(busiest_routes(data, Origin, Destination))
})

test_that("busiest_routes returns correct route", {
  data = readr::read_csv(system.file("extdata", "passengers.csv", package="airlinestatssp25"))
  result = busiest_routes(data, from, to)
  expect_equal(result$location1[[1]], "JFK")
  expect_equal(result$location2[[1]], "SFO")
  expect_equal(result$Passengers[[1]], 4)
})
