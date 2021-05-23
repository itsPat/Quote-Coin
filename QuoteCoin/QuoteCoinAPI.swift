//
//  QuoteCoinAPI.swift
//  QuoteCoin
//
//  Created by Russell Weber on 2021-05-16.
//  Copyright © 2021 trudev. All rights reserved.
//

import Foundation

class QuoteCoinAPI {
    let listOfPossibleExchanges: [ExchangeRequestModel] = [Binance(),
                                                           BitFinex(),
                                                           CoinBase(),
                                                           Kraken(),
                                                           KuCoin()]
    var exchanges: [ExchangeModel]?
    var allTickers = [Ticker]()


    func fetchAllExchanges(success: @escaping ([ExchangeModel]) -> Void,
                           failure: @escaping (Error?) -> Void) {
        var exchanges = [ExchangeModel]()
        let group = DispatchGroup()
        for exchange in listOfPossibleExchanges {
            group.enter()
            self.fetchTickersFrom(exchange) { (model) in
                exchanges.append(model)
                group.leave()
            } failure: { (error) in
                failure(error)
                group.leave()
            }
            group.wait()
        }
        self.exchanges = exchanges
        success(exchanges)
    }

    /// fetch all tickers from specified exchange
    func fetchTickersFrom(_ exchange: ExchangeRequestModel,
                            success: @escaping ((ExchangeModel) -> Void),
                            failure: @escaping ((Error?) -> Void)) {

        var components = URLComponents()
        let endpoint = getAllTickersEndpoint(exchange)
        components.host = exchange.baseURL
        components.scheme = exchange.scheme
        components.path = endpoint

        if exchange is BitFinex {
            components.queryItems = [ URLQueryItem(name: "symbols", value: "ALL") ]
        }
        var returnedModel = ExchangeModel(name: exchange.name, tickers: [])

        let task = URLSession.shared.dataTask(with: components.url!) { (data, response, error) in
            guard let data = data else { failure(error); return }
            returnedModel.tickers = self.getTickersFrom(data, exchange: exchange)
            if !returnedModel.tickers.isEmpty {
                self.exchanges?.append(returnedModel)
                self.allTickers += returnedModel.tickers
                success(returnedModel)
            } else {
                failure(error)
            }
        }
        task.resume()
    }

    private func getAllTickersEndpoint(_ exchange: ExchangeRequestModel) -> String {
        var endpoint = ""
        switch exchange {
        case let exchange as Binance:
            endpoint = exchange.tickerPriceEndpoint
        case let exchange as CoinBase:
            endpoint = exchange.allAssetsEndpoint
        case let exchange as Kraken:
            endpoint = exchange.allPairsEndpoint
        case let exchange as KuCoin:
            endpoint = exchange.allTickersEndpoint
        case let exchange as BitFinex:
            endpoint = exchange.tickerPriceEndpoint
        default:
            return endpoint
        }
        return endpoint
    }

    private func getTickersFrom(_ data: Data, exchange: ExchangeRequestModel) -> [Ticker] {
        switch exchange {
        case is KuCoin:
            let model = try? JSONDecoder().decode(KuCoinTickerReseponse.self, from: data)
            return model?.data?.ticker ?? []
        case is Kraken:
            var model: KrakenTickerResponse?
            model = try? JSONDecoder().decode(KrakenTickerResponse.self, from: data)
            var tickers = [Ticker]()
            for (_, ticker) in model?.result ?? [:] {
                tickers.append(ticker)
            }
            return tickers
        case is BitFinex:
            var tickers = [Ticker]()
            if let array = try? JSONSerialization.jsonObject(with: data, options: []) as? [[Any]] {
                for ticker in array {
                    if let symbol = ticker[0] as? String,
                       let price = ticker[7] as? Double {
                        let ticker = Ticker(symbol: symbol,
                                            price: String(price),
                                            id: symbol)
                        tickers.append(ticker)
                    }
                }
            }
            return tickers
        default:
            let model = try? JSONDecoder().decode([Ticker].self, from: data)
            return model ?? []
        }
    }
}
