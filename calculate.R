devtools::load_all()

DATA_PATH = Sys.getenv("DATA_PATH")

data = load_data(file.path(DATA_PATH, "air_sample.csv"),
                 file.path(DATA_PATH, "L_CITY_MARKET_ID.csv"),
                 file.path(DATA_PATH, "L_CARRIERS.csv"))

busiest_routes(data, Origin, Dest)

# This may be misleading, however, as some metropolitan areas have only one airport
# (for example, Raleigh-Durham or Las Vegas), while others have more (for example,
# New York or Los Angeles). We can repeat the analysis grouping by "market", which
# groups these airports together.
# Now, we can see what the most popular air route is, by summing up the number of
# passengers carried.
busiest_routes(data, OriginCity, DestCity)
