//
//  ExchangeHandlingModels.swift
//  QuoteCoin
//
//  Created by Russell Weber on 2021-05-23.
//  Copyright © 2021 trudev. All rights reserved.
//

import Foundation

struct KrakenTickerResponse: Codable {
    let error: [String?]
    let result: [String?: Ticker?]
}

struct KuCoinTickerReseponse: Codable {
    let code: String?
    let data: KuCoinData?
}

struct KuCoinData: Codable {
    let time: Int?
    let ticker: [Ticker]
}
