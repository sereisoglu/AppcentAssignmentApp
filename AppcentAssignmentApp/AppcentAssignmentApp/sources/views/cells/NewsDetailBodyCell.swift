//
//  NewsDetailBodyCell.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit
import LBTATools

final class NewsDetailBodyCell: UITableViewCell {
    private let titleLabel = Label(text: nil, type: .title3, weight: .bold, color: .tintPrimary, numberOfLines: 0)
    private let descriptionLabel = Label(text: nil, type: .body1, weight: .medium, color: .tintSecondary, numberOfLines: 0)
    private let contentLabel = Label(text: nil, type: .body1, weight: .medium, color: .tintPrimary, numberOfLines: 0)
    
    private let authorHolderView = UIView()
    private let authorIconView = IconImageView(size: .pt22, icon: .personFill, tintColor: .tintSecondary)
    private let authorLabel = Label(text: nil, type: .body1, weight: .medium, color: .tintSecondary, numberOfLines: 0)
    
    private let dateHolderView = UIView()
    private let dateIconView = IconImageView(size: .pt22, icon: .calendar, tintColor: .tintSecondary)
    private let dateLabel = Label(text: nil, type: .body1, weight: .medium, color: .tintSecondary, numberOfLines: 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        authorHolderView.hstack(
            authorIconView,
            authorLabel, spacing: Sizing.space5pt, alignment: .center
        )
        
        dateHolderView.hstack(
            dateIconView,
            dateLabel, spacing: Sizing.space5pt, alignment: .center
        )
        
        stack(
            stack(
                titleLabel,
                descriptionLabel, spacing: Sizing.space5pt
            ),
            hstack(
                authorHolderView,
                dateHolderView, spacing: Sizing.space10pt, alignment: .center, distribution: .fillEqually
            ),
            contentLabel, spacing: Sizing.space20pt
        ).withMargins(.init(top: Sizing.space20pt, left: Sizing.space16pt, bottom: 0, right: Sizing.space16pt))
    }
    
    func setData(
        titleText: String?,
        descriptionText: String?,
        authorText: String?,
        dateText: String?,
        contentText: String?
    ) {
        if let titleText = titleText {
            titleLabel.isHidden = false
            
            titleLabel.setData(text: titleText)
        } else {
            titleLabel.isHidden = true
        }
        
        if let descriptionText = descriptionText {
            descriptionLabel.isHidden = false
            
            descriptionLabel.setData(text: descriptionText)
        } else {
            descriptionLabel.isHidden = true
        }
        
        if let authorText = authorText {
            authorHolderView.isHidden = false
            
            authorLabel.setData(text: authorText)
        } else {
            authorHolderView.isHidden = true
        }
        
        if let dateText = dateText {
            dateHolderView.isHidden = false
            
            dateLabel.setData(text: dateText)
        } else {
            dateHolderView.isHidden = true
        }
        
        if let contentText = contentText {
            contentLabel.isHidden = false
            
            contentLabel.setData(text: contentText)
        } else {
            contentLabel.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
