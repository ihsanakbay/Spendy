//
//  CustomBackground.swift
//  Spendy
//
//  Created by Ihsan Akbay on 2019-07-07.
//  Copyright © 2019 Ihsan Akbay. All rights reserved.
//

import UIKit

class CustomBackground: UIView {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        let firstColor = #colorLiteral(red: 0.04928276688, green: 0.05894096941, blue: 0.06756242365, alpha: 1)
        let secondColor = #colorLiteral(red: 0.1098657027, green: 0.1496905386, blue: 0.1709896624, alpha: 1)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }

}
