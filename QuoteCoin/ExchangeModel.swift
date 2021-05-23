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

    init(from decoder: Decoder) throws {
        let keyMap = [
            "symbol": ["symbol", "display_name", "wsname"],
            "price": ["price"],
        ]
        let container = try decoder.container(keyedBy: AnyKey.self)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        func decode<Value>(_ key: String) throws -> Value where Value: Decodable {
            return try container.decode(Value.self, forMappedKey: key, in: keyMap)
        }

        symbol = try decode("symbol")
        id = try decode("id")
        price = try values.decodeIfPresent(String.self, forKey: .price)
    }
}

struct ExchangeModel {
    let name: String
    let tickers: [Ticker]
}
// used for handling multiple coding keys
struct AnyKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}

extension KeyedDecodingContainer where K == AnyKey {
    func decode<T>(_ type: T.Type, forMappedKey key: String, in keyMap: [String: [String]]) throws -> T where T : Decodable{

        for key in keyMap[key] ?? [] {
            if let value = try? decode(T.self, forKey: AnyKey(stringValue: key)) {
                return value
            }
        }

        return try decode(T.self, forKey: AnyKey(stringValue: key))
    }
}
