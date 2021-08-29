//
//  UIImageView+Extension.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit

extension UIImageView {
    convenience public init(named image: String? = nil, contentMode: UIView.ContentMode = .scaleAspectFill, tintColor: UIColor? = nil) {
        if let image = image {
            self.init(image: UIImage(named: image))
        } else {
            self.init(image: nil)
        }
        
        self.contentMode = contentMode
        self.clipsToBounds = true
        self.tintColor = tintColor
    }
}
