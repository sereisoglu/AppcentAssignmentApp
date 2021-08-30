//
//  Color.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit

enum Color: String {
    case tintPrimary = "tint/primary"
    case tintSecondary  = "tint/secondary"
    case tintTertiary = "tint/tertiary"
    
    case fillPrimary = "fill/primary"
    
    case backgroundDefault = "background/default"
    
    case clear
    
    var value: UIColor {
        switch self {
        case .clear:
            return UIColor.clear
        default:
            return UIColor(named: "\(rawValue)") ?? UIColor.clear
        }
    }
}
