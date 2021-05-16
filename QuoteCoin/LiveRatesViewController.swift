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
    
    
    var coins = [
        Coin(name: "Bitcoin", symbol: "BTC", priceUSD: 50152, percentChange: 4.52),
        Coin(name: "Ethereum", symbol: "ETH", priceUSD: 1828, percentChange: -1.52),
        Coin(name: "Litecoin", symbol: "LTC", priceUSD: 259, percentChange: 2.52),
        Coin(name: "Ripple", symbol: "XRP", priceUSD: 21, percentChange: 41.52),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        LiveCoinCell.registerCell(in: collectionView)
        setupSearchBar()
    }
    
    func setupSearchBar() {
        let searchBar = SearchBar(frame: .zero)
        navigationItem.titleView = searchBar
        
        if let container = searchBar.superview {
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                searchBar.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20),
                searchBar.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20),
                searchBar.topAnchor.constraint(equalTo: container.topAnchor),
                searchBar.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                searchBar.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }

}

extension LiveRatesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        coins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        LiveCoinCell.cell(for: collectionView, at: indexPath, with: coins[indexPath.item])
    }
    
}

extension LiveRatesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.bounds.inset(by: collectionView.contentInset).width
        return CGSize(width: w, height: 70)
    }
    
}

extension LiveRatesViewController: UICollectionViewDelegate {
    
}
