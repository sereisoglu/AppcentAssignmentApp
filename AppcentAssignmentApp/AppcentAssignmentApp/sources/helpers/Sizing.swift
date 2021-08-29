//
//  Sizing.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit

struct Sizing {
    // MARK: - General
    
    static let deviceSize: CGSize = UIScreen.main.bounds.size
    
    // MARK: - Column
    
    static let oneColumn: CGFloat = deviceSize.width - (Sizing.space16pt + Sizing.space16pt)
    static let twoColumns: CGFloat = (deviceSize.width - (Sizing.space16pt + Sizing.space12pt + Sizing.space16pt)) / 2
    
    // MARK: - Space
    
    static let space5pt: CGFloat = 5
    static let space10pt: CGFloat = 10
    static let space11pt: CGFloat = 11
    static let space12pt: CGFloat = 12
    static let space15pt: CGFloat = 15
    static let space16pt: CGFloat = 16
    static let space20pt: CGFloat = 20
    
    // MARK: - Corner Radius
    
    static let cornerRadius10pt: CGFloat = 10
    static let cornerRadius12pt: CGFloat = 12
    
    // MARK: Padding
    
    static let paddingRow: UIEdgeInsets = .linearSides(v: Sizing.space11pt, h: Sizing.space15pt)

    // MARK: Image View
    
    static let imageViewAspectRatio: CGFloat = 2 / 3
    static let imageViewBase: CGSize = .init(width: 300, height: 200)
    static var imageViewSmall: CGSize = {
        let height: CGFloat = FontType.body1.value.lineHeight + (2 * FontType.body2.value.lineHeight)
        return CGSize.init(width: height / imageViewAspectRatio, height: height)
    }()
    static var imageViewDetail: CGSize = {
        let width: CGFloat = Sizing.oneColumn
        return CGSize.init(width: width, height: width * imageViewAspectRatio)
    }()
}
