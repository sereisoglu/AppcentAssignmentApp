//
//  NewsViewModel.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import Foundation
import NewsAPI

protocol NewsViewModelDelegate: AnyObject {
    func getDataForNewsViewModel(error: ErrorModel?)
}

final class NewsViewModel {
    weak var delegate: NewsViewModelDelegate?
    
    private(set) var data: PaginationModel<NewsModel>?
    
    private(set) var state: InformingState = .loading
    
    func fetchData() {
        state = .loading
        
        APIService.shared.request(
            endpoint: .topHeadlines(
                countryCode: LocalizationUtility.getRegionCode()
            ),
            page: 1
        ) { [weak self] (result: Result<PaginationModel<NewsModel>?, ErrorModel>) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let data):
                if data?.items.isNotEmpty ?? false {
                    self.state = .data
                } else {
                    self.state = .emptyOrError(
                        headerText: "Empty",
                        messageText: "No news"
                    )
                }
                
                self.data = data
                
                self.delegate?.getDataForNewsViewModel(error: nil)
                
            case .failure(let error):
                self.state = .emptyOrError(
                    headerText: error.title ?? "API Error",
                    messageText: error.message ?? "An error has occurred."
                )
                
                self.delegate?.getDataForNewsViewModel(error: error)
            }
        }
    }
    
    func fetchDataForPagination() {
        data?.setIsPaginating(isPaginating: true)
        data?.increasePage()
        
        APIService.shared.request(
            endpoint: .topHeadlines(
                countryCode: LocalizationUtility.getRegionCode()
            ),
            page: data?.page ?? 2
        ) { [weak self] (result: Result<PaginationModel<NewsModel>?, ErrorModel>) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let data):
                self.data?.appendItems(items: data?.items)
                
                self.delegate?.getDataForNewsViewModel(error: nil)
                
            case .failure(let error):
                self.state = .emptyOrError(
                    headerText: error.title ?? "API Error",
                    messageText: error.message ?? "An error has occurred."
                )
                
                self.delegate?.getDataForNewsViewModel(error: error)
            }
            
            self.data?.setIsPaginating(isPaginating: false)
        }
    }
}
