//
//  QuoteCoinAPI.swift
//  QuoteCoin
//
//  Created by Russell Weber on 2021-05-16.
//  Copyright © 2021 trudev. All rights reserved.
//

import Foundation

class QuoteCoinAPI {

    enum NetworkError: Error {
        case invalidUrl, failedToParseResponse, noData
    }

    let listOfPossibleExchanges: [ExchangeRequestModel] = [Binance(),
                                                      BitFinex(),
                                                      CoinBase(),
                                                      Kraken(),
                                                      KuCoin()]
    var exchanges: [ExchangeModel]?
    var allTickers = [Ticker]()
    var coins = [String: (tickers: [Ticker], graphData: [String])]()


    func fetchAllExchanges(completion: @escaping (Result<[ExchangeModel], Error>) -> Void) {
        var exchanges = [ExchangeModel]()
        let group = DispatchGroup()
        for exchange in listOfPossibleExchanges {
            group.enter()
            self.fetchTickersFrom(exchange) { (res) in
                switch res {
                case .success(let model):
                    exchanges.append(model)
                    group.leave()
                case .failure(let err):
                    print("\(#function) failed with error: \(err)")
                    group.leave()
                }
            }
            group.wait()
        }
        self.exchanges = exchanges
        completion(exchanges.isEmpty ? .failure(NetworkError.noData) : .success(exchanges))
    }

    /// fetch all tickers from specified exchange
    func fetchTickersFrom(_ exchange: ExchangeRequestModel,
                          completion: @escaping (Result<ExchangeModel, Error>) -> Void) {

        var components = URLComponents()
        components.host = exchange.baseURL
        components.scheme = exchange.scheme
        components.path = exchange.allAssetsEndpoint

        if exchange is BitFinex {
            components.queryItems = [ URLQueryItem(name: "symbols", value: "ALL") ]
        }
        var returnedModel = ExchangeModel(name: exchange.name, tickers: [])

        URLSession.shared.dataTask(with: components.url!) { (data, response, error) in
            guard let data = data else { completion(.failure(NetworkError.noData)); return }
            if let err = error {
                completion (.failure(err))
            }

            returnedModel.tickers = self.getTickersFrom(data, exchange: exchange)
            if !returnedModel.tickers.isEmpty {
                self.exchanges?.append(returnedModel)
                for ticker in returnedModel.tickers {
                    if ticker.symbol.contains("BTC") {
                        let coinName = ticker.symbol.replacingOccurrences(of: "BTC", with: "")
                        self.coins[coinName]?.tickers.append(ticker)
                        self.getChartData(for: ticker,
                                     on: exchange) { (res) in
                            switch res {
                            case .success(let data):
                                self.coins[coinName]?.graphData = data

                            case .failure(let err):
                                completion(.failure(err))
                            }
                        }
                    }
                }
            } else {
                completion(.failure(NetworkError.failedToParseResponse))
            }
        }.resume()
    }

    private func getChartData(for ticker: Ticker,
                              on exchange: ExchangeRequestModel,
                              completion: @escaping (Result<[String], Error>) -> Void) {
        var components = URLComponents()
        components.host = exchange.baseURL
        components.scheme = exchange.scheme
        components.path = getChartEndpoint(with: exchange.graphDataEndpoint,
                                           tickerID: ticker.id ?? ticker.symbol,
                                           for: exchange)
        components.queryItems = getChartQueryItems(for: ticker, on: exchange)
        URLSession.shared.dataTask(with: components.url!) { (data, response, error) in
            guard let data = data else { completion(.failure(NetworkError.noData)); return }
            if let err = error {
                completion(.failure(err))
            }
            do {
                if let data = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                    for entry in data {
                        //convert entry to String and put in order
                    }
                }
//                completion(.success(data))
            } catch {
                completion(.failure(NetworkError.failedToParseResponse))
            }
            
        }.resume()
    }

    private func getChartQueryItems(for ticker: Ticker,
                                    on exchange: ExchangeRequestModel) -> [URLQueryItem]? {
        switch exchange {
        case is Binance:
            return [URLQueryItem(name: "symbol", value: ticker.id ?? ticker.symbol),
                    URLQueryItem(name: "interval", value: "1d")]
        case is Kraken:
            return [URLQueryItem(name: "pair", value: ticker.id ?? ticker.symbol)]
        case is KuCoin:
            return [URLQueryItem(name: "symbol", value: ticker.symbol),
                    URLQueryItem(name: "type", value: "1day")]
        default:
            return nil
        }
    }

    private func getChartEndpoint(with baseURL: String,
                                  tickerID: String,
                                  for exchange: ExchangeRequestModel) -> String {
        switch exchange {
        case is CoinBase:
            return String(format: baseURL, tickerID)
        case is BitFinex:
            return String(format: baseURL, "1D", tickerID)
        default:
            return baseURL
        }
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
