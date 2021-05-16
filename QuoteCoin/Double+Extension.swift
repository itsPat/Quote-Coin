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
        if self >= 10000, self <= 999999 {
            return String(format: "%.1fK", locale: Locale.current,self/1000).replacingOccurrences(of: ".0", with: "")
        }
        return String(format: "%.2f", abs(self))
    }
    
    var formatted: String {
        return String(format: "%.2f", abs(self))
    }
    
}
