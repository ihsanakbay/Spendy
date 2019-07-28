//
//  CustomTextField.swift
//  Spendy
//
//  Created by Ihsan Akbay on 2019-06-30.
//  Copyright © 2019 Ihsan Akbay. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    var textRectOffset: CGFloat = 10
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = 6.0
        self.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.zero
        self.clipsToBounds = true
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
