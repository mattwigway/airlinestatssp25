devtools::load_all()

data = load_data("../moddesign/odum-modular-design-r/data/air_sample.csv",
                 "../moddesign/odum-modular-design-r/data/L_CITY_MARKET_ID.csv",
                 "../moddesign/odum-modular-design-r/data/L_CARRIERS.csv")

market_shares(data, OriginCity, OperatingCarrierName)
market_shares(data, OriginCity, TicketingCarrierName)

market_shares(data, Origin, OperatingCarrierName)
market_shares(data, Origin, TicketingCarrierName)
