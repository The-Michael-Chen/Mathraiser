//
//  UIButtonExtension.swift
//  Mathraiser
//
//  Created by Michael Chen on 6/15/20.
//  Copyright © 2020 ChenOutOfTen. All rights reserved.
//

import Foundation
import UIKit


extension UIButton {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = false
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
        
    }
    
}
