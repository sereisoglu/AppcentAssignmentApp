//
//  NewsCell.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit
import LBTATools

final class NewsCell: UITableViewCell {
    private let photoHolderView = UIView()
    private let photoView = PhotoView()
    
    private let titleLabel = Label(text: nil, type: .body1, weight: .bold, color: .tintPrimary, numberOfLines: 0)
    private let descriptionLabel = Label(text: nil, type: .body2, weight: .medium, color: .tintSecondary, numberOfLines: 2)
    private let sourceAndDateLabel = Label(text: nil, type: .body3, weight: .medium, color: .tintTertiary)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        photoHolderView.stack(
            photoView.withSize(Sizing.imageViewSmall),
            UIView()
        )
        
        stack(
            hstack(
                stack(
                    titleLabel,
                    descriptionLabel
                ),
                photoHolderView, spacing: Sizing.space10pt, alignment: .top
            ),
            sourceAndDateLabel
        ).withMargins(.linearSides(v: Sizing.space11pt, h: Sizing.space16pt))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoView.imageDownloadCancel()
    }
    
    func setData(
        imageUrl: String?,
        titleText: String,
        descriptionText: String?,
        sourceAndDateText: String?
    ) {
        if let imageUrl = imageUrl {
            photoHolderView.isHidden = false
            
            photoView.setData(imageUrl: imageUrl)
        } else {
            photoHolderView.isHidden = true
        }
        
        titleLabel.setData(text: titleText)
        
        if let descriptionText = descriptionText {
            descriptionLabel.isHidden = false

            descriptionLabel.setData(text: descriptionText)
        } else {
            descriptionLabel.isHidden = true
        }

        if let sourceAndDateText = sourceAndDateText {
            sourceAndDateLabel.isHidden = false

            sourceAndDateLabel.setData(text: sourceAndDateText)
        } else {
            sourceAndDateLabel.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
