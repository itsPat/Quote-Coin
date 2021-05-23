//
//  ExchangeModel.swift
//  QuoteCoin
//
//  Created by Russell Weber on 2021-05-16.
//  Copyright © 2021 trudev. All rights reserved.
//

import Foundation

struct Ticker: Codable {
    var symbol: String?
    var price: String?
    var id: String?
//    var dayChangeData: [Any]?
//    var graphData: [Any]?


    init(_ exchange: ExchangeRequestModel, from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        var symbolKey = "symbol"
        var priceKey = "price"
        switch exchange.self {
        case is Binance:
            price = try values.decode(String.self, forKey: CodingKeys(stringValue: priceKey) ?? .price)
        case is CoinBase:
            symbolKey = "display_name"
            id = try values.decode(String.self, forKey: .id)
        case is Kraken:
            symbolKey = "wsname"
        default:
            priceKey = ""
        }

        symbol = try values.decode(String.self, forKey: CodingKeys(stringValue: symbolKey) ?? .symbol)
    }
}

struct ExchangeModel {
    let name: String
    let tickers: [Ticker]
}
