//
//  Cento.swift
//
//  Created by Paul Ossenbruggen on 5/15/17.
//
//

import Foundation

// CentoCent - One 10000 of a cent. 
struct Cento {
    static var cFormatter : NumberFormatter? = nil

    let rawValue : Int
    
    var value : Int {
        // centocent conversion, keep in centocents
        // so precision is retained. Also since dealing in
        // money, avoid doubles.
        return rawValue / 10000
    }
    
    static func currencyFormatter() -> NumberFormatter {
        // expensive to initialize the number formatter, do it once.
        
        if cFormatter == nil {
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "USD"
            
            cFormatter = formatter
            return formatter
        }
        return cFormatter!
    }
}
