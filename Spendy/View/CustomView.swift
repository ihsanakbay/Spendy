//
//  CustomView.swift
//  Spendy
//
//  Created by Ihsan Akbay on 2019-06-30.
//  Copyright © 2019 Ihsan Akbay. All rights reserved.
//

import UIKit

class CustomView: UIView {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = 10.0
        self.layer.shadowRadius = 1.0
        self.layer.shadowColor = #colorLiteral(red: 0.7982520461, green: 0.02503738366, blue: 0.2300806046, alpha: 1).cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = true
        
        let firstColor = #colorLiteral(red: 0.1189024076, green: 0.1336162388, blue: 0.1421546936, alpha: 1)
        let secondColor = #colorLiteral(red: 0.1672205329, green: 0.1965060234, blue: 0.217971772, alpha: 1)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }

}
