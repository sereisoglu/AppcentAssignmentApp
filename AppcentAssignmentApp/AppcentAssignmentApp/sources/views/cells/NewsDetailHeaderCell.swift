//
//  NewsDetailHeaderCell.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit
import LBTATools

final class NewsDetailHeaderCell: UITableViewCell {
    private let newsImageView = NewsImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        newsImageView.addFillSuperview(superview: self, padding: .init(top: Sizing.space20pt, left: Sizing.space16pt, bottom: 0, right: Sizing.space16pt))
    }
    
    func setData(imageUrl: String?) {
        if let imageUrl = imageUrl {
            newsImageView.isHidden = false
            
            newsImageView.setData(imageUrl: imageUrl)
        } else {
            newsImageView.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
