//
//  NewsDetailController.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit

final class NewsDetailController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Source"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItems = [
            .init(image: Icon.heart.value, style: .plain, target: self, action: nil),
            .init(image: Icon.squareAndArrowUp.value, style: .plain, target: self, action: nil)
        ]
    }
}
