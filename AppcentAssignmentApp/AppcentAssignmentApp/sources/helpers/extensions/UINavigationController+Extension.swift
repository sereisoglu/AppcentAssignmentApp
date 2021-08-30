//
//  UINavigationController+Extension.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit

extension UINavigationController {
    func hidesBottomBarPushViewController(_ viewController: UIViewController, animated: Bool) {
        viewControllers.last?.hidesBottomBarWhenPushed = true
        
        pushViewController(viewController, animated: animated)
        
        viewControllers.first?.hidesBottomBarWhenPushed = false
    }
}
