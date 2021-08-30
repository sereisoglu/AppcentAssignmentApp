//
//  FavoriteManager.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 30.08.2021.
//

import Foundation
import NewsAPI

final class FavoriteManager {
    private init() {}
    static let shared = FavoriteManager()
    
    private(set) var favoriteNewsData = NewsModels()
    
    func isFavorite(id: String) -> Bool {
        return favoriteNewsData.contains(where: { $0.id == id })
    }
    
    func append(news: NewsModel) {
        favoriteNewsData.append(news)
    }
    
    func remove(id: String) {
        guard let index = favoriteNewsData.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        favoriteNewsData.remove(at: index)
    }
}
