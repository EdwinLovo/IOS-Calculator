//
//  UIButtonExtension.swift
//  Calculadora
//
//  Created by Edwin on 9/3/19.
//  Copyright © 2019 Edwin. All rights reserved.
//

import UIKit

extension UIButton {

    // Round border
    func round(){
        layer.cornerRadius = bounds.height/2
        clipsToBounds = true
    }
    
    // Shine
    func shine(){
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.5
        }) { (completation) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
            })
        }
    }
    
}
