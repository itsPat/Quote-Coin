//
//  ExchangeModel.swift
//  QuoteCoin
//
//  Created by Russell Weber on 2021-05-16.
//  Copyright © 2021 trudev. All rights reserved.
//

import Foundation
/// Common ticker struct, used by all exchanges
struct Ticker: Codable {
    var symbol: String
    var price: String?
    var id: String?
//    var dayChangeData: [Any]?

    init(from decoder: Decoder) throws {
        let keyMap = [
            "symbol": ["symbol", "display_name", "wsname"],
            "price": ["price", "buy"],
            "id": ["id", "altname"]
        ]
        let container = try decoder.container(keyedBy: AnyKey.self)

        func decode<Value>(_ key: String) throws -> Value? where Value: Decodable {
            return try container.decodeIfPresent(Value.self, forMappedKey: key, in: keyMap)
        }

        symbol = try container.decode(String.self, forMappedKey: "symbol", in: keyMap)
        id = try decode("id")
        price = try decode("price")
    }

    init(symbol: String, price: String?, id: String?) {
        self.symbol = symbol
        self.price = price
        self.id = id
    }
}
/// Common exchange model, used to represent all exchanges
struct ExchangeModel {
    let name: String
    var tickers: [Ticker]
}
/// used for handling multiple coding keys for the same values across responses from different APIs
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
/// used for handling multiple coding keys for the same values across responses from different APIs
extension KeyedDecodingContainer where K == AnyKey {
    func decodeIfPresent<T>(_ type: T.Type, forMappedKey key: String, in keyMap: [String: [String]]) throws -> T? where T : Decodable{

        for key in keyMap[key] ?? [] {
            if let value = try? decodeIfPresent(T.self, forKey: AnyKey(stringValue: key)) {
                return value
            } else {
                return nil
            }
        }

        return try decodeIfPresent(T.self, forKey: AnyKey(stringValue: key))
    }

    func decode<T>(_ type: T.Type, forMappedKey key: String, in keyMap: [String: [String]]) throws -> T where T : Decodable{

        for key in keyMap[key] ?? [] {
            if let value = try? decode(T.self, forKey: AnyKey(stringValue: key)) {
                return value
            }
        }

        return try decode(T.self, forKey: AnyKey(stringValue: key))
    }
}
