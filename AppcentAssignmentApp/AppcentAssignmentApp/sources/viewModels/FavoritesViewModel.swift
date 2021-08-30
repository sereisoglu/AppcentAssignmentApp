//
//  FavoritesViewModel.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import Foundation
import NewsAPI

protocol FavoritesViewModelDelegate: AnyObject {
    func getDataForFavoritesViewModel()
}

final class FavoritesViewModel {
    weak var delegate: FavoritesViewModelDelegate?
    
    private(set) var data = NewsModels()
    
    private(set) var state: InformingState = .loading
    
    func fetchData() {
        data = FavoriteManager.shared.favoriteNewsData
        
        if data.isNotEmpty {
            self.state = .data
        } else {
            self.state = .emptyOrError(
                headerText: "Empty",
                messageText: "No favorites"
            )
        }
        
        delegate?.getDataForFavoritesViewModel()
    }
}
