//
//  PhotoView.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit
import LBTATools
import Nuke

final class PhotoView: UIView {
    private let iconView = IconImageView(size: .pt30, icon: .photo, tintColor: .tintSecondary)
    private let imageView = UIImageView(contentMode: .scaleAspectFill)
    
    init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = Color.fillPrimary.value
        
        layer.cornerRadius = Sizing.cornerRadius10pt
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
        clipsToBounds = true
        
        layer.borderWidth = 2
        layer.borderColor = Color.tintPrimary.value.withAlphaComponent(0.25).cgColor
        frame = imageView.frame.insetBy(dx: -2, dy: -2)
        
        iconView.addCenterInSuperview(superview: self)
        
        imageView.addFillSuperview(superview: self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       if #available(iOS 13.0, *) {
           if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
               layer.borderColor = Color.tintPrimary.value.withAlphaComponent(0.25).cgColor
           }
       }
    }
    
    func setData(imageUrl: String?) {
        imageView.isHidden = true
        
        if let imageUrl = imageUrl,
           let url = URL(string: imageUrl) {
            Nuke.loadImage(
                with: url,
                options: .init(
                    transition: .fadeIn(duration: 0.33)
                ),
                into: imageView
            ) { [weak self] (result: Result<ImageResponse, ImagePipeline.Error>) in
                guard let self = self else {
                    return
                }
                
                switch result {
                case .success:
                    self.imageView.isHidden = false
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func imageDownloadCancel() {
        Nuke.cancelRequest(for: imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
