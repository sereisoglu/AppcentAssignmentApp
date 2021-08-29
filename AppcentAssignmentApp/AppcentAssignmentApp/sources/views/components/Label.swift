//
//  Label.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit

final class Label: UILabel {
    private let type: FontType
    private var attributes: [NSAttributedString.Key : Any]
    
    init(
        text: String?,
        type: FontType,
        weight: FontWeight,
        color: Color?,
        alignment: NSTextAlignment = .left,
        numberOfLines: Int = 1,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail
    ) {
        self.type = type
        attributes = AttributedStringUtility.generate(type: type, weight: weight, color: nil, alignment: alignment, lineBreakMode: lineBreakMode)
        
        super.init(frame: .zero)
        
        self.numberOfLines = numberOfLines
        
        setData(text: text)
        setData(color: color)
        
        sizeToFit()
    }
    
    func setData(text: String?) {
        guard let text = text else {
            return
        }
        
        setData(texts: [.init(string: text)])
    }
    
    func setData(color: Color?) {
        guard let color = color else {
            return
        }
        
//        attributes[.foregroundColor] = color.value
        textColor = color.value
    }
    
    func setData(texts: [Text]?) {
        guard let texts = texts else {
            return
        }
        
        let attributedText = NSMutableAttributedString()
        
        texts.forEach {
            switch $0.type {
            case .default:
                attributedText.append(.init(string: $0.string, attributes: attributes))
                
            case .underlined:
                var underlinedAttributes = attributes
                underlinedAttributes[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
                
                attributedText.append(.init(string: $0.string, attributes: underlinedAttributes))
                
            case .medium:
                var mediumAttributes = attributes
                mediumAttributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: type.value.size, weight: .medium)
                
                attributedText.append(.init(string: $0.string, attributes: mediumAttributes))
                
            case .bold:
                var boldAttributes = attributes
                boldAttributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: type.value.size, weight: .bold)
                
                attributedText.append(.init(string: $0.string, attributes: boldAttributes))
            }
        }
        
        self.attributedText = attributedText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
