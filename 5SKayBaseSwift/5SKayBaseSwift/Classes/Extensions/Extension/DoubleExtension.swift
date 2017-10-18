//
//  DoubleExtension.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/14/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//


import UIKit

extension Double {
    
    struct Number {
        static let formatterBYR: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.positiveFormat = "#,##0 ¤"
            formatter.negativeFormat = "-#,##0 ¤"
            formatter.currencySymbol = "Руб"
            
            return formatter
        }()
        
        static let formatterJP: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.numberStyle = .currency
            
            return formatter
        }()
        
        static let formatterEUR: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "pt_PT")
            formatter.numberStyle = .currency
            
            return formatter
        }()
        
        static let formatterUSD: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.numberStyle = .currency
            
            return formatter
        }()
        
        static let formatterRUB: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 0
            
            return formatter
        }()
        
        static let formatterVN: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "vi-VN") // "en-VN" uses character "," and "vn-VN" uses character "."
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 0
            
            return formatter
        }()
        
        static let formatterLocale: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            
            return formatter
        }()
    }
    
    func stringDistance() -> String {
        if self < 1000 {
            return NSNumber(value: Int(self) as Int).stringValue + "m"
        } else if self < 100000 {
            return  "\(Int(self/1000))," + "\(Int(self.truncatingRemainder(dividingBy: 1000))/100)km"
        } else {
            return "\(Int(self/1000))km"
        }
    }
    
    var currencyLocale: String { return Number.formatterLocale.string(from: NSNumber(value: self)) ?? "" }
    var currencyJP: String { return Number.formatterJP.string(from: NSNumber(value: self)) ?? "¥0" }
    var currencyVN: String { return Number.formatterVN.string(from: NSNumber(value: self)) ?? "₫ 0" }
}


extension Int {
    var currencyVN: String { return "\(self) ₫" }
}

