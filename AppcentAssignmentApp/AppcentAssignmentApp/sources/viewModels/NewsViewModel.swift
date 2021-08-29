//
//  NewsViewModel.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import Foundation
import NewsAPI

protocol NewsViewModelModelDelegate: AnyObject {
    func getData(error: ErrorModel?)
}

final class NewsViewModel {
    weak var delegate: NewsViewModelModelDelegate?
    
    private(set) var data: PaginationModel<NewsModel>?
    
    private(set) var state: InformingState = .loading
    
//    private(set) var query: String = ""
    
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
                self.state = .data
                
                self.data = data
                
                self.delegate?.getData(error: nil)
                
            case .failure(let error):
                self.state = .emptyOrError(
                    headerText: error.title ?? "API Error",
                    messageText: error.message ?? "An error has occurred."
                )
                
                self.delegate?.getData(error: error)
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
                
                self.delegate?.getData(error: nil)
                
            case .failure(let error):
                self.state = .emptyOrError(
                    headerText: error.title ?? "API Error",
                    messageText: error.message ?? "An error has occurred."
                )
                
                self.delegate?.getData(error: error)
            }
            
            self.data?.setIsPaginating(isPaginating: false)
        }
    }
    
//    func fetchEverythingData(query: String) {
//        guard self.query != query else {
//            return
//        }
//
//        self.query = query
//
//        state = .loading
//
//        APIService.shared.request(
//            endpoint: .everything(
//                query: query,
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
//                self.state = .data
//
//                self.data = data
//
//                self.delegate?.getData(error: nil)
//
//            case .failure(let error):
//                self.state = .emptyOrError(
//                    headerText: error.title ?? "API Error",
//                    messageText: error.message ?? "An error has occurred."
//                )
//
//                self.delegate?.getData(error: error)
//            }
//        }
//    }
//
//    func fetchOtherPage() {
//        let query = self.query
//
//        data?.setIsPaginating(isPaginating: true)
//        data?.increasePage()
//
//        APIService.shared.request(
//            endpoint: .topHeadlines(
//                countryCode: LocalizationUtility.getRegionCode()
//            ),
//            page: data?.page ?? 2
//        ) { [weak self] (result: Result<PaginationModel<NewsModel>?, ErrorModel>) in
//            guard let self = self else {
//                return
//            }
//
//            switch result {
//            case .success(let data):
//                if query == self.query {
//                    self.data?.appendItems(items: data?.items)
//                }
//
//            case .failure(let error):
//                self.state = .emptyOrError(
//                    headerText: error.title ?? "API Error",
//                    messageText: error.message ?? "An error has occurred."
//                )
//
//                self.delegate?.getData(error: error)
//
//                return
//            }
//
//            self.data?.setIsPaginating(isPaginating: false)
//
//            self.delegate?.getData(error: nil)
//        }
//    }
//
//    func reset() {
//        data = nil
//
//        state = .emptyOrError(
//            headerText: "Start Searching",
//            messageText: "Search all of PAA for movies."
//        )
//
//        query = ""
//    }
}
