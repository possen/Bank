//
//  DataStore,swift
//
//  Created by Paul Ossenbruggen on 5/9/17.
//
//

import Foundation
import BrightFutures

let getAll = "api/v2/core/get-all-transactions"

struct Month {
    let key : String
    let transactions : [Transaction]
    let spent : Cento
    let income : Cento
    let average : Cento
}

class DataStore {
    weak var delegate : TableViewDataManagerDelegate? = nil
    var httpClient : HTTPClient = HTTPClientInstance()
    var coellated : [Month] = []
    var dataLoaded : (() -> Void)? = nil

    var transactions : [Transaction] = [] {
        didSet {
            delegate?.update()
        }
    }

    func fetch() -> Future<[Transaction], NSError> {
        return httpClient.post(query: getAll, parameters: nil).flatMap { json in
            self.parse(json: json)
        }.onSuccess { transactions in
            self.transactions = transactions
            self.coellate(transactions: transactions)
        }.onFailure { error in
            print(error)
        }.andThen { (_) in
            if let dataLoaded = self.dataLoaded {
                dataLoaded()
            }
        }
    }
    
    private func monthKey(date: Date) -> String {
        let cal = Calendar.current
        let year = cal.component(.year, from: date)
        let month = cal.component(.month, from: date)
        let key = "\(year)-\(month)"
        return key
    }
    
    func coellate(transactions: [Transaction]) {
        var prev = ""
        var month : [Transaction] = []
        var spent = 0
        var income = 0
        
        for transaction in transactions {
            let curr = monthKey(date: transaction.transactionTime)
            
            if curr != prev && month.count != 0 {
                let averageSpending = spent / month.count
                coellated.append(Month(key: curr,
                                       transactions: month,
                                       spent: Cento(rawValue: abs(spent)),
                                       income: Cento(rawValue: income),
                                       average: Cento(rawValue: abs(averageSpending))))
                month = []
                spent = 0
                income = 0
            }
            
            month.append(transaction)
            let amount = transaction.amount.rawValue
            
            if amount < 0 {
                spent += amount
            } else {
                income += amount
            }

            prev = curr
        }
    }

    
    private func parse(json: JSON) -> Future<[Transaction], NSError> {
        return Future<[Transaction], NSError> { completion in
            
            if let response = json as? [String: Any] {
                
                guard let errorResult = response["error"],
                        let errorString = errorResult as? String,
                        errorString == "no-error" else {
                            
                    completion(.failure(createError(code: .parse)))
                    return
                }
                print(response)
                if let transactionJSON = response["transactions"] as? [[String: Any]] {
                    
                    let transactions = createTransactions(jsonObjects: transactionJSON)
                    completion(.success(transactions))
                } else {
                    completion(.failure(createError(code: .parse)))
                }
            }
        }
    }
    
    private func createTransactions(jsonObjects: [[String: Any]]) -> [Transaction] {
        return jsonObjects.flatMap {
            do {
                return try Transaction(json: $0)
            } catch _ {
                print("error loading transaction ")
            }
            return nil
        }
    }
}


