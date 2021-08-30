//
//  NewsAPI.swift
//  NewsAPI
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import Foundation
import Alamofire

public final class NewsAPI {
    private init() {}
    public static let shared = NewsAPI()
    
    let BASE_URL = "https://newsapi.org"
    var API_KEY = ""
    var API_PAGE_LIMIT = 0
    
    public func setUp(apiKey: String, pageLimit: Int) {
        self.API_KEY = apiKey
        self.API_PAGE_LIMIT = pageLimit
    }
    
    public func request<T: Decodable>(
        endpoint: Endpoint,
        page: Int? = nil,
        completion: @escaping (Result<T?, ErrorModel>) -> Void
    ) {
        var parameters = endpoint.parameters
        
        if let page = page {
            if parameters == nil {
                parameters = Parameters()
            }
            
            parameters?["page"] = page
        }
        
        print("\(endpoint.httpMethod.rawValue) REQUEST\nurl: \(endpoint.urlString)\nparameters: \(parameters ?? Parameters())\n")
        
        let dataRequest = AF.request(
            endpoint.urlString,
            method: endpoint.httpMethod,
            parameters: parameters,
            headers: endpoint.headers
        )
        
        dataRequest.response { (result) in
            if let error = result.error {
                completion(.failure(.init(
                    title: "Internal Error",
                    message: error.localizedDescription
                )))
                
                return
            }
            
            guard let response = result.response else {
                completion(.failure(.init(
                    title: "Nil Response",
                    message: "An error has occurred."
                )))
                
                return
            }
            
            if (200 ..< 300) ~= response.statusCode { // success
                if let data = result.data {
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        
                        completion(.success(decodedData))
                    } catch {
                        print(error)
                        
                        completion(.failure(.init(
                            title: "\(T.self) Decode Error",
                            message: error.localizedDescription
                        )))
                    }
                } else {
                    completion(.success(nil))
                }
            } else { // failure
                if let data = result.data {
                    do {
                        let decodedData = try JSONDecoder().decode(ErrorModel.self, from: data)
                        
                        completion(.failure(decodedData))
                    } catch {
                        print(error)
                        
                        completion(.failure(.init(
                            title: "\(ErrorModel.self) Decode Error",
                            message: error.localizedDescription
                        )))
                    }
                } else {
                    completion(.failure(.init(
                        title: "Nil Error",
                        message: "An error has occurred."
                    )))
                }
            }
        }
    }
}
