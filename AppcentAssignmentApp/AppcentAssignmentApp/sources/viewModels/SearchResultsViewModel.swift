//
//  SearchResultsViewModel.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import Foundation
import NewsAPI

protocol SearchResultsViewModelDelegate: AnyObject {
    func getDataForSearchResultsViewModel(error: ErrorModel?)
}

final class SearchResultsViewModel {
    weak var delegate: SearchResultsViewModelDelegate?
    
    private(set) var data: PaginationModel<NewsModel>?
    
    private(set) var state: InformingState = .data
    
    private(set) var query: String = ""
    
    init() {
        reset()
    }
    
    func fetchData(query: String) {
        guard self.query != query else {
            return
        }

        self.query = query

        state = .loading

        NewsAPI.shared.request(
            endpoint: .everything(
                query: query,
                languageCode: LocalizationUtility.getLanguageCode()
            ),
            page: 1
        ) { [weak self] (result: Result<PaginationModel<NewsModel>?, ErrorModel>) in
            guard let self = self,
                  query == self.query else {
                return
            }

            switch result {
            case .success(let data):
                if data?.items.isNotEmpty ?? false {
                    self.state = .data
                } else {
                    self.state = .emptyOrError(
                        headerText: "No Results",
                        messageText: "for \"\(query)\""
                    )
                }

                self.data = data

                self.delegate?.getDataForSearchResultsViewModel(error: nil)

            case .failure(let error):
                self.state = .emptyOrError(
                    headerText: error.title ?? "API Error",
                    messageText: error.message ?? "An error has occurred."
                )

                self.delegate?.getDataForSearchResultsViewModel(error: error)
            }
        }
    }

    func fetchDataForPagination() {
        let query = self.query

        data?.setIsPaginating(isPaginating: true)
        data?.increasePage()

        NewsAPI.shared.request(
            endpoint: .everything(
                query: query,
                languageCode: LocalizationUtility.getLanguageCode()
            ),
            page: data?.page ?? 2
        ) { [weak self] (result: Result<PaginationModel<NewsModel>?, ErrorModel>) in
            guard let self = self,
                  query == self.query else {
                return
            }

            switch result {
            case .success(let data):
                self.data?.appendItems(items: data?.items)
                
                self.delegate?.getDataForSearchResultsViewModel(error: nil)

            case .failure(let error):
                self.state = .emptyOrError(
                    headerText: error.title ?? "API Error",
                    messageText: error.message ?? "An error has occurred."
                )

                self.delegate?.getDataForSearchResultsViewModel(error: error)
            }

            self.data?.setIsPaginating(isPaginating: false)
        }
    }

    func reset() {
        data = nil

        state = .emptyOrError(
            headerText: "Start Searching",
            messageText: "Search all of AAA for news."
        )

        query = ""
    }
}
