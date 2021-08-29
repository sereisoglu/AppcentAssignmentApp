//
//  TabBarController.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit
import LBTATools

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createNavigationController(
                icon: .newspaper,
                selectedIcon: .newspaperFill,
                title: "News",
                viewController: NewsController()
            ),
            createNavigationController(
                icon: .heart,
                selectedIcon: .heartFill,
                title: "Favorites",
                viewController: FavoritesController()
            )
        ]
    }
    
    private func createNavigationController(
        icon: Icon,
        selectedIcon: Icon,
        title: String,
        viewController: UIViewController
    ) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: viewController)
        
        navigationController.tabBarItem.image = icon.value
        navigationController.tabBarItem.selectedImage = selectedIcon.value
        navigationController.title = title
        
        return navigationController
    }
}
