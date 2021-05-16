//
//  SearchBar.swift
//  QuoteCoin
//
//  Created by Patrick Trudel on 2021-05-16.
//  Copyright © 2021 trudev. All rights reserved.
//

import UIKit

class SearchBar: UIView {

    let stack = UIStackView(frame: .zero)
    let leftButton = UIButton(frame: .zero)
    let textField = UITextField(frame: .zero)
    let rightButton = UIButton(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 22
        layer.masksToBounds = true
        backgroundColor = UIColor.white.withAlphaComponent(0.05)
        
        
        
        leftButton.setImage(
            UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(scale: .large)),
            for: .normal
        )
        leftButton.isUserInteractionEnabled = false
        leftButton.tintColor = UIColor.white.withAlphaComponent(0.5)
        
        rightButton.setImage(
            UIImage(systemName: "line.horizontal.3.decrease", withConfiguration: UIImage.SymbolConfiguration(scale: .large)),
            for: .normal
        )
        rightButton.tintColor = UIColor.white.withAlphaComponent(0.5)
        
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "Search for a Coin", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)
        ])
        
        addSubview(stack)
        [leftButton, textField, rightButton].forEach {
            stack.addArrangedSubview($0)
        }
        setupConstraints()
    }
    
    func setupConstraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Left Button
            leftButton.widthAnchor.constraint(equalToConstant: 44),
            leftButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Right Button
            rightButton.widthAnchor.constraint(equalToConstant: 44),
            rightButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Stack View
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 6),
            stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -6)
        ])
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
