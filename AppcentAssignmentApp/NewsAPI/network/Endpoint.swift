//
//  Endpoint.swift
//  NewsAPI
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import Foundation
import Alamofire

public enum Endpoint: Equatable {
    case topHeadlines(countryCode: String)
    case everything(query: String, languageCode: String)
}

extension Endpoint {
    var urlString: String {
        return "\(NewsAPI.shared.BASE_URL)/\(version)/\(path)"
    }
    
    var version: String {
        switch self {
        case .topHeadlines:
            return "v2"
            
        case .everything:
            return "v2"
        }
    }
    
    var path: String {
        switch self {
        case .topHeadlines:
            return "top-headlines"
            
        case .everything:
            return "everything"
        }
    }
}

extension Endpoint {
    var httpMethod: HTTPMethod {
        switch self {
        case .topHeadlines,
             .everything:
            return .get
        }
    }
}

extension Endpoint {
    var headers: HTTPHeaders? {
        switch self {
        case .topHeadlines,
             .everything:
            return nil
        }
    }
}

extension Endpoint {
    var parameters: Parameters? {
        switch self {
        case .topHeadlines(let countryCode):
            return [
                "apiKey": NewsAPI.shared.API_KEY,
                "pageSize": NewsAPI.shared.API_PAGE_LIMIT,
                "country": countryCode,
                "category": "general"
            ]
            
        case .everything(let query, let languageCode):
            return [
                "apiKey": NewsAPI.shared.API_KEY,
                "pageSize": NewsAPI.shared.API_PAGE_LIMIT,
                "language": languageCode,
                "sortBy": "relevant",
                "q": query
            ]
        }
    }
}
