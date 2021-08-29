//
//  NewsModel.swift
//  NewsAPI
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import Foundation

public struct NewsModel: Decodable {
    var source: NewsSourceModel?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

public struct NewsSourceModel: Decodable {
    var id:String?
    var name: String?
}
