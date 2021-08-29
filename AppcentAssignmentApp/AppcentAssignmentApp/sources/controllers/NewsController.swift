//
//  NewsController.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit
import NewsAPI

class NewsController: UIViewController {
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search for news"
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "News"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .white
        
//        APIService.shared.request(
//            endpoint: .everything(
//                query: "car",
//                languageCode: LocalizationUtility.getLanguageCode()
//            ),
//            page: 1
//        ) { [weak self] (result: Result<PaginationModel<NewsModel>?, ErrorModel>) in
//            guard let self = self else {
//                return
//            }
//
//            switch result {
//            case .success(let data):
//                print(data)
//
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}
