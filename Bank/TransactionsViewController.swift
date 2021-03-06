//
//  ViewController.swift
//
//  Created by Paul Ossenbruggen on 5/9/17.
//
//

import UIKit
import BrightFutures


class TransactionsViewController: UITableViewController {
    
    static private let green = UIColor(colorLiteralRed: 0.722, green: 0.886, blue: 0.592, alpha: 0.6)
    private var transactionDataManagerTableViewAdaptor : TableViewAdaptor!

    var store = DataStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.httpClient = MockHTTPClient(filename: "allData")
        
        transactionDataManagerTableViewAdaptor = TableViewAdaptor (
            tableView: tableView,
            sections: [],
            didChangeHandler: { [unowned self] in
                
                let sections : [TableSectionAdaptor] = self.store.coellated.map {
                    return self.adaptor(month: $0)
                }

                self.transactionDataManagerTableViewAdaptor.sections = sections
                self.tableView.reloadData()
            }
        )
        
        store.delegate = transactionDataManagerTableViewAdaptor

        store.fetch()
            .onSuccess { transactions in
                print("loaded \(transactions.count) transactions")
            }.onFailure { error in
                self.displayError(error)
            }
    }
    
    fileprivate func displayError(_ error: (Error)) {
        print(error)
        let alert = UIAlertController(title: "NetworkError", message: "error \(error)", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: {})
        })
        alert.addAction(okAction)
        alert.popoverPresentationController?.sourceView = view
        self.present(alert, animated: true, completion: {})
    }
    
    
    func adaptor(month : Month) -> TableViewAdaptorSection<TransactionCell, Transaction> {
        let formatter = Cento.currencyFormatter()
        let spent =  formatter.string(from: NSNumber(value: month.spent.value))!
        let average = formatter.string(from: NSNumber(value: month.average.value))!
        let income = formatter.string(from: NSNumber(value: month.income.value))!
        let header = "\(month.key) \(income) \(average) (\(spent))"
        
        let transactionAdaptor = TableViewAdaptorSection<TransactionCell, Transaction> (
            cellReuseIdentifier: "TransactionCell",
            title: header,
            height: 30,
            items: month.transactions)
        { cell, model, index in
            
            cell.backgroundColor = (index % 2 == 0)
                ? TransactionsViewController.green
                : UIColor.white
            
            cell.viewData = TransactionCell.ViewData(transaction: model)
        }
        return transactionAdaptor
    }
}

