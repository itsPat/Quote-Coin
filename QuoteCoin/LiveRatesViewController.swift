//
//  ViewController.swift
//  QuoteCoin
//
//  Created by Patrick Trudel on 2021-05-16.
//  Copyright © 2021 trudev. All rights reserved.
//

import UIKit

struct Coin {
    let name: String
    let symbol: String
    let priceUSD: Double
    let percentChange: Double
}

class LiveRatesViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    var coins = [
        Coin(name: "Bitcoin", symbol: "BTC", priceUSD: 50152.12, percentChange: 4.52),
        Coin(name: "Ethereum", symbol: "ETH", priceUSD: 1828.25, percentChange: -1.52),
        Coin(name: "Litecoin", symbol: "LTC", priceUSD: 259.49, percentChange: 2.52),
        Coin(name: "Ripple", symbol: "XRP", priceUSD: 21.01, percentChange: 41.52),
    ]

    let api = QuoteCoinAPI()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = SearchBar(frame: .zero)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        LiveCoinCell.registerCell(in: collectionView)
        api.fetchAllExchanges { (exchanges) in
            // we have api.allTickers available, or the list of all exchanges
            let usdTickers = self.api.allTickers.filter {
                $0.symbol?.contains("USD") ?? false &&
                $0.price != nil &&
                !($0.id?.contains("TEST") ?? true)
            }
            print(usdTickers)
        } failure: { (error) in
            // frowny error face?
            print("💩")
        }

    }

}


// MARK: - UICollectionViewDataSource

extension LiveRatesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        coins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        LiveCoinCell.cell(for: collectionView, at: indexPath, with: coins[indexPath.item])
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension LiveRatesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.bounds.inset(by: collectionView.contentInset).width
        return CGSize(width: w, height: 70)
    }
    
}


// MARK: - UICollectionViewDelegate

extension LiveRatesViewController: UICollectionViewDelegate {

}
