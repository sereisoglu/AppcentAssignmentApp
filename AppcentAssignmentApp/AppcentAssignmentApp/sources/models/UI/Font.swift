//
//  Font.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit

enum FontType {
    case title1
    case title2
    case title3
    case body1
    case body2
    case body3
    case body3Underlined
    case body4
    
    var value: (size: CGFloat, lineHeight: CGFloat, kerning: CGFloat, baselineOffset: CGFloat) {
        switch self {
        case .title1:
            return (size: 34.0, lineHeight: 41.0, kerning: 0.37, baselineOffset: 0.5)
        case .title2:
            return (size: 28.0, lineHeight: 34.0, kerning: 0.36, baselineOffset: 0.5)
        case .title3:
            return (size: 22.0, lineHeight: 28.0, kerning: 0.35, baselineOffset: 0.5)
        case .body1:
            return (size: 17.0, lineHeight: 22.0, kerning: -0.41, baselineOffset: 0.5)
        case .body2:
            return (size: 15.0, lineHeight: 20.0, kerning: -0.24, baselineOffset: 0.5)
        case .body3:
            return (size: 13.0, lineHeight: 18.0, kerning: -0.08, baselineOffset: 0.5)
        case .body3Underlined:
            return (size: 13.0, lineHeight: 18.0, kerning: -0.08, baselineOffset: 0)
        case .body4:
            return (size: 11.0, lineHeight: 13.0, kerning: 0.06, baselineOffset: 0.5)
        }
    }
}

enum FontWeight {
    case medium
    case semibold
    case bold
    
    var value: UIFont.Weight {
        switch self {
        case .medium:
            return .medium
        case .semibold:
            return .semibold
        case .bold:
            return .bold
        }
    }
}

enum FontDecoration {
    case none
    case underline
}
