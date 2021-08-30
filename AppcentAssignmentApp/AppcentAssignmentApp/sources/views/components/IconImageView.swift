//
//  IconImageView.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 30.08.2021.
//

import UIKit

final class IconImageView: UIImageView {
    init(size: IconSize, icon: Icon?, tintColor: Color?) {
        super.init(frame: .zero)
        
        withSize(size.value)
        
        if let icon = icon {
            setData(icon: icon)
        }
        
        if let tintColor = tintColor {
            setData(color: tintColor)
        }
    }
    
    func setData(icon: Icon) {
        image = icon.value
    }
    
    func setData(color: Color) {
        tintColor = color.value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
