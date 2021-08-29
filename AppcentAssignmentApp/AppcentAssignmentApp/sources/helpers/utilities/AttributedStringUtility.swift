//
//  AttributedStringUtility.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit

final class AttributedStringUtility {
    class func generate(
        type: FontType,
        weight: FontWeight,
        color: Color?,
        alignment: NSTextAlignment = .left,
        lineBreakMode: NSLineBreakMode
    ) -> [NSAttributedString.Key : Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = type.value.lineHeight
        paragraphStyle.minimumLineHeight = type.value.lineHeight
        paragraphStyle.lineSpacing = 0.0
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = lineBreakMode
        
        var attributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: type.value.size, weight: weight.value),
            .paragraphStyle: paragraphStyle,
            .kern: type.value.kerning,
            .baselineOffset: type.value.baselineOffset
        ]
        
        if let color = color {
            attributes[.foregroundColor] = color.value
        }
        
        return attributes
    }
}
