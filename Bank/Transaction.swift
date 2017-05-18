//
//  Transaction.swift
//
//  Created by Paul Ossenbruggen on 5/13/17.
//
//

import Foundation


struct Transaction {
    let accountID : String
    let aggregationTime : Int
    let amount : Cento
    let categorization : String
    let clearDate : Date
    let isPending : Bool
    let memoOnlyForTesting : String
    let merchant : String
    let payeeNameOnlyForTesting : String
    let rawMerchant : String
    let transactionID : String
    let transactionTime : Date
    
    init(json: [String: Any]) throws {
        //
        // note: probably would want to use a JSON parsing library for this.
        // but doing it manually to not depend on other libraries.
        //
        let formatter = Transaction.dateFormatter()
        
        guard let amount         = json["amount"] as? Int,
            let accountID        = json["account-id"] as? String,
            let clearDate        = json["clear-date"] as? Double,
            let isPending        = json["is-pending"] as? Bool,
            let transactionID    = json["transaction-id"] as? String,
            let transactionTime  = json["transaction-time"] as? String,
            let transactionDate  = formatter.date(from: transactionTime) else {
                throw createError(code: .badRecord)
        }
        
        self.amount          = Cento(rawValue: amount)
        self.accountID       = accountID
        self.clearDate       = Date(timeIntervalSince1970: clearDate)
        self.isPending       = isPending
        self.transactionID   = transactionID
        self.transactionTime = transactionDate
        
        self.aggregationTime = json["aggregation-time"] as? Int ?? 0
        self.categorization = json["Shopping"] as? String ?? ""
        self.memoOnlyForTesting = json["memo-only-for-testing"] as? String ?? ""
        self.merchant = json["merchant"] as? String ?? ""
        self.payeeNameOnlyForTesting = json["payee-name-only-for-testing"] as? String ?? ""
        self.rawMerchant = json["raw-merchant"] as? String ?? ""
    }
    
    static var isoFormatter : DateFormatter? = nil
    
    static func dateFormatter() -> DateFormatter {
        
        // expensive to initialize the date formatter, do it once.
        if isoFormatter == nil {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm.ss.SSSZ"
            isoFormatter = formatter
            return formatter
        } else {
            return isoFormatter!
        }
    }
}
