//
//  UIButtonExtensions.swift
//  TheSwifter
//
//  Created by Michael Ardizzone on 5/16/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    //we'll use this function to make our buttons look better
    func makeoverButton() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15
    }
}

extension UIView {
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
}

