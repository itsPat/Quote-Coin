//
//  QuoteCoinAPI.swift
//  QuoteCoin
//
//  Created by Russell Weber on 2021-05-16.
//  Copyright © 2021 trudev. All rights reserved.
//

import Foundation

class QuoteCoinAPI {

    func fetchExchangeModel(exchange: ExchangeRequestModel,
                            success: @escaping (() -> Void),
                            failure: @escaping ((Error?) -> Void)) {

        var request: URLRequest

        switch exchange {
        case let exchange as CoinBase:
            let endpoint = exchange.allAssetsEndpoint
            guard var baseURL = URL(string: exchange.baseURL) else {
                // failure invalid request
                return
            }
            baseURL.appendPathComponent(endpoint)
//            tickerURL.pathComponents["$CoinPair"] = "BNB-BTC"
            request = URLRequest(url: baseURL)

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil || data == nil {
                    failure(error)
                }

                do {
                    let decoder = JSONDecoder()
                }
            }
        default:
            guard let tickerURL = URL(string: exchange.baseURL + exchange.tickerPriceEndpoint) else {
                // failure invalid request
                return
            }
            request = URLRequest(url: tickerURL)

        }
    }



}

extension QuoteCoinAPI {
    /// This API should be used in API handlers, to convert data types or throw an error.
    ///
    /// Usage example:
    /// let responseDict: [String: Any] = try convertOrThrow(serviceResponse)
    public func convertOrThrow<T>(_ response: Any?) throws -> T {
        guard let result = response as? T else {
            throw NSError()
        }

        return result
    }

    /// This is a mehthod to decode generic type from provided `Dictionary` response.
    ///
    /// Usage Example:
    /// let model: CustomerProfileModel = try decodeJSONOrThrow(serviceResponse)
    ///
    /// - Parameters:
    ///   - response: Any object, which could be decoded to a dictionary.
    ///   - allowDebugPrint: A boolean value indicating wether or not to print JSON response on console.
    ///                      Default is false
    /// - Returns: generic type, that conforms to Decodable protocol
    /// - Throws: instance of Error
    public func decodeJSONOrThrow<T: Decodable>(_ response: Any?) throws -> T {
        let responseDict: [String: Any] = try convertOrThrow(response)

        let data = try JSONSerialization.data(withJSONObject: responseDict, options: [])
        let decoder = JSONDecoder()
        let model = try decoder.decode(T.self, from: data)
        return model
    }
}
