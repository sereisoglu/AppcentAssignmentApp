//
//  NewsAPITests.swift
//  NewsAPITests
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import XCTest
@testable import NewsAPI

class NewsAPITests: XCTestCase {

    func test_TopHeadlines_Success() {
        let expectation = expectation(description: "test_TopHeadlines_Success")
        
        APIService.shared.request(
            endpoint: .topHeadlines(
                countryCode: "us"
            ),
            page: 1
        ) { (result: Result<PaginationModel<NewsModel>?, ErrorModel>) in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                
            case .failure(let error):
                XCTAssertNil(error)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_Everything_Success() {
        let expectation = expectation(description: "test_Everything_Success")
        
        APIService.shared.request(
            endpoint: .everything(
                query: "car crash",
                languageCode: "en"
            ),
            page: 1
        ) { (result: Result<PaginationModel<NewsModel>?, ErrorModel>) in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                
            case .failure(let error):
                XCTAssertNil(error)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

}
