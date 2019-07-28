//
//  CustomButtonView.swift
//  Spendy
//
//  Created by Ihsan Akbay on 2019-06-30.
//  Copyright © 2019 Ihsan Akbay. All rights reserved.
//

import UIKit

class CustomButtonView: UIButton {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = 6.0
        self.layer.shadowRadius = 10.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.clipsToBounds = true
    }

}
