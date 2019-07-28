//
//  Extensions.swift
//  Spendy
//
//  Created by Ihsan Akbay on 2019-06-23.
//  Copyright © 2019 Ihsan Akbay. All rights reserved.
//

import UIKit

extension String {
    var doubleConverter: Double {
        let converter = NumberFormatter()
        converter.decimalSeparator = ","
        if let result = converter.number(from: self) {
            return Double(result.doubleValue)
        } else {
            converter.decimalSeparator = "."
            if let result = converter.number(from: self) {
                return Double(result.doubleValue)
            }
        }
        return 0
    }
}

func getCurrentDate() -> String {
    let now = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "d.MM.yyyy"
    return formatter.string(from: now)
}

func getCurrency(value: Any) -> String{
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale.current
    let priceString = currencyFormatter.string(for: value)!
    return priceString
}
