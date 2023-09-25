//
//  ActivityIndicatorView.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit

final class ActivityIndicatorView: UIView {
    enum Size {
        case pt20
        case pt30
        
        var value: CGSize {
            switch self{
            case .pt20:
                return .equalEdge(20)
            case .pt30:
                return .equalEdge(30)
            }
        }
    }
    
    var animating: Bool = false {
        didSet {
            isHidden = !animating
            
            if animating {
                activityIndicatorView.startAnimating()
            } else {
                activityIndicatorView.stopAnimating()
            }
        }
    }
    
    private let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    init(
        size: Size,
        tintColor: Color?
    ) {
        super.init(frame: .zero)
        
        isHidden = true
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.isUserInteractionEnabled = false
        
        let aspectRatio = size.value.width / Size.pt20.value.width
        activityIndicatorView.transform = CGAffineTransform(scaleX: aspectRatio, y: aspectRatio)
        
        withSize(size.value)
        
        activityIndicatorView.addCenterInSuperview(superview: self)
        
        if let tintColor = tintColor {
            setData(tintColor: tintColor)
        }
    }
    
    func setData(tintColor: Color) {
        activityIndicatorView.color = tintColor.value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
