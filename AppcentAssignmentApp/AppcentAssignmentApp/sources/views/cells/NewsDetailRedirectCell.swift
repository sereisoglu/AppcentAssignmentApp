//
//  NewsDetailRedirectCell.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 30.08.2021.
//

import UIKit
import LBTATools

final class NewsDetailRedirectCell: UITableViewCell {
    private let redirectLabel = Label(text: nil, type: .body1, weight: .medium, color: .tintPrimary, numberOfLines: 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        redirectLabel.addFillSuperview(superview: self, padding: .linearSides(v: Sizing.space20pt, h: Sizing.space16pt))
        
        selectionStyle = .none
    }
    
    func setData(
        sourceText: String
    ) {
        redirectLabel.setData(texts: [
            .init(type: .default, string: "Visit "),
            .init(type: .underlined, string: sourceText),
            .init(type: .default, string: " for more information.")
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
