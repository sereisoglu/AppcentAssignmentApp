//
//  Color.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit

enum Color: String {
    case brandPrimary = "brand/primary"
    case brandSecondary = "brand/secondary"
    
    case tintPrimary = "tint/primary"
    case tintSecondary  = "tint/secondary"
    case tintTertiary = "tint/tertiary"
    case tintWhite = "tint/white"
    case tintWhite75 = "tint/white-75"
    case tintRed = "tint/red"
    case tintBlue = "tint/blue"
    case tintYellow = "tint/yellow"
    case tintGreen = "tint/green"
    
    case fillPrimary = "fill/primary"
    case fillSecondary = "fill/secondary"
    case fillSegmentedBar = "fill/segmentedBar"
    
    case backgroundDefault = "background/default"
    case backgroundGroupedPrimary = "background/grouped/primary"
    case backgroundGroupedSecondary = "background/grouped/secondary" // ActionSheetController
    case backgroundSegmentedBar = "background/segmentedBar"
    
    case separator = "separator"
    
    case shadow = "shadow"
    
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
