//
//  TransactionCell.swift
//
//  Created by Paul Ossenbruggen on 5/13/17.
//
//

import UIKit

class TransactionCell: UITableViewCell {
    
    @IBOutlet weak var titleView : UILabel!
    @IBOutlet weak var amountView : UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    struct ViewData {
        let title: String
        let amount: Cento
    }
    
    var viewData: ViewData? {
        didSet {
            titleView.text = viewData?.title
            let intAmount = viewData?.amount.value
            let currencyFormatter = Cento.currencyFormatter()
            amountView.text = currencyFormatter.string(from: NSNumber(value: intAmount!))
        }
    }
    
    func configure(model: Any) {
        let transaction = model as! Transaction
        viewData = ViewData(transaction: transaction)
    }
}

extension TransactionCell.ViewData {
    init(transaction: Transaction) {
        self.title = transaction.merchant
        self.amount = transaction.amount 
    }
}

