//
//  NewsModel.swift
//  NewsAPI
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import Foundation

public struct NewsModel: Decodable {
    public var source: NewsSourceModel?
    public var author: String?
    public var title: String?
    public var description: String?
    public var url: String?
    public var urlToImage: String?
    public var publishedAt: String?
    public var content: String?
}

public struct NewsSourceModel: Decodable {
    public var id:String?
    public var name: String?
}
