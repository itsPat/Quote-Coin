//
//  ExchangeRequestModel.swift
//  QuoteCoinAPI
//
//  Created by Russell Weber on 2021-05-15.
//

import Foundation

protocol ExchangeRequestModel {
    /// the name of the exchange
    var name: String { get }
    /// base URL used to connect to API
    var scheme: String { get }
    var baseURL: String { get }
    var graphDataEndpoint: String { get }
    var tickerPriceEndpoint: String { get }
    var bookTickersEndpoint: String { get }
}

struct Binance: ExchangeRequestModel {
    var name: String = "Binance"
    var scheme: String = "https"
    var baseURL: String = "api.binance.com"
    /// Endpoint for a specific tickers graph Data
    /// - param: symbol = Ticker. symbol to fetch graphdata
    /// - param: interval. intervals used in graph
    /// - param: startTime. start time for graph If startTime and endTime are not sent, the most recent klines are returned.
    /// - param: endTime. end time for graph
    /// - param: limit. limit for graph
    var graphDataEndpoint: String = "/api/v3/klines"
    /// endpoint for the current price of a particular ticker
    /// - the param symbol isnt required, but will return all symbols if missing
    var tickerPriceEndpoint: String = "/api/v3/ticker/price"
    /// endpoint for orderBook
    /// - If the param symbol is not sent, bookTickers for all symbols will be returned in an array.
    var bookTickersEndpoint: String = "/api/v3/ticker/bookTicker"
    /// Endpoint used for getting the 24hr change of a ticker
    /// - If the param symbol is not sent, tickers for all symbols will be returned in an array.
    var dayAvgPriceEndpoint: String = "/api/v3/ticker/24hr"
    /**
    call using the below URLs as example
     No parameter    curl -X GET "https://api.binance.com/api/v3/exchangeInfo"
     symbol    curl -X GET "https://api.binance.com/api/v3/exchangeInfo?symbol=BNBBTC"
     symbols    curl -X GET "https://api.binance.com/api/v3/exchangeInfo?symbols=%5B%22BNBBTC%22,%22BTCUSDT%22%5D" or curl -g GET 'https://api.binance.com/api/v3/exchangeInfo?symbols=["BTCUSDT","BNBBTC"]'
     If any symbol provided in either symbol or symbols do not exist, the endpoint will throw an error.
     */
    var exchangeInfoEndpoint: String = "/api/v3/exchangeInfo"
}

struct CoinBase: ExchangeRequestModel {
    var name: String = "Coinbase"
    var scheme: String = "https"
    var baseURL: String = "api.pro.coinbase.com"
    /// endpoint for getting graph data for specified coin pair
    /// - param: $CoinPair must be replaced w valid coin pair to get data. I.E BNB-BTC
    var graphDataEndpoint: String = "/products/$CoinPair/candles"
    /// endpoint to get value of coin in different currencies
    /// - param: $CoinPair must be replaced to receive valid ticker info. I.E BNB-BTC
    var tickerPriceEndpoint: String = "/products/$CoinPair/ticker"
    /// endpoint to get orderBook
    /// - param $CoinPair must be replaced w valid coin pair. I.E BNB-BTC
    var bookTickersEndpoint: String = "/products/$CoinPair/book"
    /// endpoint to get 24hr change for specific coin pair
    /// - param: $CoinPair must be replaced to get valid stats. I.E BNB-BTC
    var dayAvgPriceEndpoint: String = "/products/$CoinPair/stats"
    /// get info about all assets available

    var allAssetsEndpoint: String = "/products"
}

struct Kraken: ExchangeRequestModel {
    var name: String = "Kraken"
    var scheme: String = "https"
    var baseURL: String = "api.kraken.com/0"
    /// endpoint returning all Open, high Low and Close data for given pair - requires API key and sign
    /// - param: pair is required. I.E pair=XBTUSD
    /// - param interval is default 1. change to 1 5 15 30 60 240 1440 10080 or 21600 (in minutes)
    /// - param: since
    var graphDataEndpoint: String = "/public/OHLC"
    /// endpoint returning price info for specified coin pair
    /// - param: pair is required to get valid data. I.E pair=XBTUSD
    var tickerPriceEndpoint: String = "/public/Ticker"
    /// endpoint to return order book info for specified pair
    /// - param: pair is required. I.E pair=XBTUSD
    var bookTickersEndpoint: String = "/public/Depth"

    var dayAvgPriceEndpoint: String = ""
    /// gets tradeable asset pairs
    var allPairsEndpoint: String = "/public/AssetPairs"
    /// get info about all assets available
    /// - refine by adding query params: asset & aclass. I.E asset=XBT,ETH & aclass=currency
    var allAssetsEndpoint: String = "/public/Assets"
}

struct KuCoin: ExchangeRequestModel {
    var name: String = "KuCoin"
    var scheme: String = "https"
    var baseURL: String = "api.kucoin.com"
    /// endpoint to get graph data for specified pair
    /// - param: symbol required. I.E symbol=BTC-USDT
    /// - param: startAt default 0. type: Long
    /// - param: endAt default 0. type Long
    /// - param: type. Type of candlestick patterns: 1min, 3min, 5min, 15min, 30min, 1hour, 2hour, 4hour, 6hour, 8hour, 12hour, 1day, 1week
    /// - returned as:
    ///     - time    Start time of the candle cycle
    ///     - open    Opening price
    ///     - close    Closing price
    ///     - high    Highest price
    ///     - low    Lowest price
    ///     - volume    Transaction volume
    ///     - turnover    Transaction amount
    var graphDataEndpoint: String = "/api/v1/market/candles"
    /// endpoint used to get ticker info for specified pair
    /// - param: symbol required. I.E symbol=BTC-USDT
    var tickerPriceEndpoint: String = "/api/v1/market/orderbook/level1"
    /// endpoint to return book orders for specified pairs
    /// - param: symbol is required. I.E
    var bookTickersEndpoint: String = "/api/v1/market/orderbook/level2_100"
    /// endpoint to return 24 hr change for specified pair
    /// - param: pair is required. I.E
    var dayAvgPriceEndpoint: String = "/api/v1/market/stats"
    /// endpoint to return a list of available markets
    var maketsEndpoint: String = "/api/v1/markets"
    var allTickersEndpoint: String = "/api/v1/market/allTickers"
}

struct BitFinex: ExchangeRequestModel {
    var name: String = "BitFinex"
    var scheme: String = "https"
    var baseURL: String = "api-pub.bitfinex.com"
    /// endpoint to return graph data, must replace params prefixed by $ with valid values
    /// - params:
    ///     - TimeFrame: $Timeframe. Available values: '1m', '5m', '15m', '30m', '1h', '3h', '6h', '12h', '1D', '7D', '14D', '1M'
    ///     - Symbol: $Symbol. The symbol you want information about. (e.g. tBTCUSD, tETHUSD, fUSD, fBTC)
    ///     - Section: $Section. Available values: "last", "hist"
    ///
    /// - returned:
    ///
    ///         // response with Section = "last"
    ///
    ///         [
    ///           MTS,
    ///           OPEN,
    ///           CLOSE,
    ///           HIGH,
    ///           LOW,
    ///           VOLUME
    ///         ]
    ///
    ///         // response with Section = "hist"
    ///         [
    ///           [
    ///            MTS,
    ///            OPEN,
    ///            CLOSE,
    ///            HIGH,
    ///            LOW,
    ///            VOLUME
    ///           ],
    ///            ...
    ///         ]

    var graphDataEndpoint: String = "/v2/candles/trade:$TimeFrame:$Symbol/Section"
    /** The tickers endpoint provides a high level overview of the state of the market. It shows the current best bid and ask, the last traded price, as well as information on the daily volume and price movement over the last day. The endpoint can retrieve multiple tickers with a single query.

     - parameter symbols required. Can be ALL. or I.E symbols=tBTCUSD,tLTCUSD,fUSD

     -  returns:
     on trading pairs (ex. tBTCUSD)
        [
        SYMBOL,
        BID,
        BID_SIZE,
        ASK,
        ASK_SIZE,
        DAILY_CHANGE,
        DAILY_CHANGE_RELATIVE,
        LAST_PRICE,
        VOLUME,
        HIGH,
        LOW
        ]
     on funding currencies (ex. fUSD)
        [
        SYMBOL,
        FRR,
        BID,
        BID_PERIOD,
        BID_SIZE,
        ASK,
        ASK_PERIOD,
        ASK_SIZE,
        DAILY_CHANGE,
        DAILY_CHANGE_RELATIVE,
        LAST_PRICE,
        VOLUME,
        HIGH,
        LOW,
        _PLACEHOLDER,
        _PLACEHOLDER,
        FRR_AMOUNT_AVAILABLE
        ]
     */
    var tickerPriceEndpoint: String = "/v2/tickers"
    /// endpoint to fetch order book data
    /// must replace parameters prefixed with $ with valid values
    /// - Params:
    ///     - Symbol: $Symbol. The symbol you want information about. (e.g. tBTCUSD, tETHUSD, fUSD, fBTC)
    ///     - Precision: $Precision. The symbol you want information about. (e.g. tBTCUSD, tETHUSD, fUSD, fBTC)
    /// - returned:
    ///
    ///// on trading pairs (ex. tBTCUSD)
    ///     [
    ///       [
    ///         PRICE,
    ///         COUNT,
    ///         AMOUNT
    ///       ],
    ///       ...
    ///     ]
///
    ///     // on funding currencies (ex. fUSD)
    ///     [
    ///       [
    ///         RATE,
    ///         PERIOD,
    ///         COUNT,
    ///         AMOUNT
    ///       ],
    ///       ...
    ///     ]
///
    ///     // on raw books (precision of R0)
    ///     // on trading currencies:
    ///     [
    ///       [
    ///         ORDER_ID,
    ///         PRICE,
    ///         AMOUNT
    ///       ],
    ///       ...
    ///     ]
///
    ///     // on funding currencies:
///
    ///     [
    ///       [
    ///         ORDER_ID,
    ///         PERIOD,
    ///         RATE,
    ///         AMOUNT
    ///       ],
    ///       ...
    ///     ]
    ///
    var bookTickersEndpoint: String = "/v2/book/$Symbol/$Precision"

    var allTickersEndpoint: String = "/v2/tickers"
}
