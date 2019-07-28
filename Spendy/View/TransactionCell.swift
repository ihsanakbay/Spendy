//
//  TransactionCell.swift
//  Spendy
//
//  Created by Ihsan Akbay on 2019-06-26.
//  Copyright © 2019 Ihsan Akbay. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var transactionNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(transaction: Transaction) {
        
        if transaction.selectedIndex == 0 {
            self.amountLabel.text = String("-\(getCurrency(value: transaction.transactionAmount))")
        } else {
            self.amountLabel.text = String(getCurrency(value: transaction.transactionAmount))
        }
        self.transactionNameLabel.text = transaction.transactionName
        self.dateLabel.text = transaction.transactionDate
    }
    

}
