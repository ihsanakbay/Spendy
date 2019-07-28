//
//  WalletCell.swift
//  Spendy
//
//  Created by Ihsan Akbay on 2019-06-23.
//  Copyright © 2019 Ihsan Akbay. All rights reserved.
//

import UIKit

class WalletCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(wallet: Wallet) {
        self.amountLabel.text = getCurrency(value: wallet.walletAmount)
        self.nameLabel.text = wallet.walletName
        self.dateLabel.text = wallet.walletDate
    }

   

}
