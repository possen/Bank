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
      
    var title : String = ""
    var cellReuseIdentifier: String = ""
    var items: [Any] = []
    var height : CGFloat { return 280.0 }
    var configure: (_ cell: Any, _ model: Any, _ index: Int) -> Void = {cell, model, index in }
    
    required init(cellReuseIdentifier: String,
                  title: String,
                  configure: @escaping (_ cell: Any,_ model: Any, _ index: Int) -> Void,
                  items:[Any]) {
        self.title = title
        self.cellReuseIdentifier = cellReuseIdentifier
        self.items = items
        self.configure = configure
        super.init(style: .default, reuseIdentifier: cellReuseIdentifier)
    }
    
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

