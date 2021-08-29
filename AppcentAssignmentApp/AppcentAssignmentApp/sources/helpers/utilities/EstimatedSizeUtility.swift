//
//  EstimatedSizeUtility.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit

final class EstimatedSizeUtility<T: UIView> {
    class func width(height: CGFloat, setData: ((T) -> Void)?) -> CGSize {
        let view = T(frame: .init(x: 0, y: 0, width: 1000, height: height))
        setData?(view)
        
        view.layoutIfNeeded()
        
        let estimatedSize = view.systemLayoutSizeFitting(.init(width: 1000, height: height))
        
        return .init(width: estimatedSize.width, height: height)
    }
    
    class func height(width: CGFloat, setData: ((T) -> Void)?) -> CGSize {
        let view = T(frame: .init(x: 0, y: 0, width: width, height: 1000))
        setData?(view)
        
        view.layoutIfNeeded()
        
        let estimatedSize = view.systemLayoutSizeFitting(.init(width: width, height: 1000))
        
        return .init(width: width, height: estimatedSize.height)
    }
}
