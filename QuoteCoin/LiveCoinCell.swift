//
//  LiveCoinCell.swift
//  QuoteCoin
//
//  Created by Patrick Trudel on 2021-05-16.
//  Copyright © 2021 trudev. All rights reserved.
//

import UIKit

class LiveCoinCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    
    static let reuseId = "LiveCoinCell"
    static let nib = UINib(nibName: reuseId, bundle: .main)
    
    static func registerCell(in collectionView: UICollectionView) {
        collectionView.register(nib, forCellWithReuseIdentifier: reuseId)
    }
    
    static func cell(for collectionView: UICollectionView, at index: IndexPath, with coin: Coin) -> LiveCoinCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: index) as! LiveCoinCell
        cell.configure(with: coin)
        return cell
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!
    
    // MARK: - Properties
    
    private var coin: Coin?
    
    func configure(with coin: Coin) {
        self.coin = coin
        nameLabel.text = coin.name
        symbolLabel.text = coin.symbol
        priceLabel.text = "$" + "\(coin.priceUSD)"
        percentChangeLabel.text = coin.percentChange > 0 ? "+\(coin.percentChange)%" : "\(coin.percentChange)%"
        percentChangeLabel.textColor = coin.percentChange > 0 ? .systemGreen : .systemRed
    }

}
