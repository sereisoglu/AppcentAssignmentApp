//
//  ErrorModel.swift
//  NewsAPI
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import Foundation

public struct ErrorModel: Decodable, Error {
    public var title: String?
    
    public var status: String?
    public var code: String?
    public var message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case code
        case message
    }
}
