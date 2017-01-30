//
//  UIView Extension.swift
//  Guru
//
//  Created by Dylan Diamond on 1/29/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func shake() {
        
        let anim = CAKeyframeAnimation( keyPath:"transform" )
        anim.values = [
            NSValue( caTransform3D:CATransform3DMakeTranslation(-8, 0, 0 ) ),
            NSValue( caTransform3D:CATransform3DMakeTranslation( 8, 0, 0 ) )
        ]
        anim.autoreverses = true
        anim.repeatCount = 2
        anim.duration = 0.07
        
        self.layer.add(anim, forKey:nil )
    }
}
