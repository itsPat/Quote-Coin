//
//  Double+Extension.swift
//  QuoteCoin
//
//  Created by Patrick Trudel on 2021-05-16.
//  Copyright © 2021 trudev. All rights reserved.
//

import Foundation

extension Double {
    
    var currencyFormatted: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        return numberFormatter.string(from: NSNumber(value: self)) ?? formattedAndTruncated
    }
    
    var formattedAndTruncated: String {
        guard 10000..<999999 ~= self else { return String(format: "%.2f", abs(self)) }
        return String(format: "%.1fK", locale: .current, self/1000).replacingOccurrences(of: ".0", with: "")
    }
    
    var formatted: String {
        return String(format: "%.2f", abs(self))
    }
    
}
