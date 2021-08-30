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
    
    private var observers = [NSObjectProtocol]()
    
    init() {
        setUpObservers()
    }
    
    private func setUpObservers() {
        guard observers.isEmpty else {
            return
        }
        
        observers = [
            NotificationCenter.default.addObserver(
                forName: .updateFavoriteNews,
                object: nil,
                queue: .main,
                using: { [weak self] (notification) in
                    guard let self = self else {
                        return
                    }
                    
                    self.fetchData()
                }
            )
        ]
    }
    
    func fetchData() {
        data = CoreDataManager.shared.getDatas()
        
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
    
    deinit {
        observers.forEach { (observer) in
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
