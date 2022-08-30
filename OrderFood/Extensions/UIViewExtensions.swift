//
//  UIViewExtensions.swift
//  OrderFood
//
//  Created by ThanhThuy on 05/08/2022.
//

import UIKit

extension UIView {
    @IBInspectable var conerRadius : CGFloat {
        get {return conerRadius}
        set {
            self.layer.cornerRadius = newValue
        }
    }
}

extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }

}
