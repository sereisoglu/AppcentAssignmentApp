//
//  ErrorModel.swift
//  NewsAPI
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import Foundation

public struct ErrorModel: Decodable, Error {
    var title: String?
    
    var status: String?
    var code: String?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case code
        case message
    }
}
