//
//  UIView+Extension.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit
import LBTATools

extension UIView {
    func addCenterInSuperview(superview: UIView, size: CGSize = .zero) {
        superview.addSubview(self)
        
        centerInSuperview(size: size)
    }
    
    open func addFillSuperview(superview: UIView,padding: UIEdgeInsets = .zero) {
        superview.addSubview(self)
        
        fillSuperview(padding: padding)
    }
}
