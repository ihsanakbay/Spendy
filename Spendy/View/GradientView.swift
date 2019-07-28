//
//  GradientView.swift
//  Spendy
//
//  Created by Ihsan Akbay on 2019-07-07.
//  Copyright © 2019 Ihsan Akbay. All rights reserved.
//

import UIKit

class GradientBGView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView(){
        let firstColor = #colorLiteral(red: 0.1814830005, green: 0.1998096704, blue: 0.2345844507, alpha: 1).cgColor
        let secondColor = #colorLiteral(red: 0.2314732075, green: 0.2548823357, blue: 0.2895936668, alpha: 1).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [firstColor, secondColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
