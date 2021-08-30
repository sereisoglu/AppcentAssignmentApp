//
//  NewsModel.swift
//  NewsAPI
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import Foundation

public typealias NewsModels = [NewsModel]

public struct NewsModel: Decodable {
    public var id: String
    
    public var sourceName: String?
    public var author: String?
    public var title: String?
    public var description: String?
    public var url: String?
    public var imageUrl: String?
    public var publishedAt: String?
    public var content: String?
    
    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case description
        case url
        case imageUrl = "urlToImage"
        case publishedAt
        case content
    }
    
    public init(
        id: String,
        sourceName: String?,
        author: String?,
        title: String?,
        description: String?,
        url: String?,
        imageUrl: String?,
        publishedAt: String?,
        content: String?
    ) {
        self.id = id
        self.sourceName = sourceName
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.imageUrl = imageUrl
        self.publishedAt = publishedAt
        self.content = content
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let source = try values.decode(NewsSourceModel?.self, forKey: .source)
        
        sourceName = source?.name
        author = try values.decode(String?.self, forKey: .author)
        title = try values.decode(String?.self, forKey: .title)
        description = try values.decode(String?.self, forKey: .description)
        url = try values.decode(String?.self, forKey: .url)
        imageUrl = try values.decode(String?.self, forKey: .imageUrl)
        publishedAt = try values.decode(String?.self, forKey: .publishedAt)
        content = try values.decode(String?.self, forKey: .content)
        
        id = "\(title ?? "")-\(publishedAt ?? "")"
        
        if author == "" {
            author = nil
        }
    }
}

public struct NewsSourceModel: Decodable {
    public var id:String?
    public var name: String?
}
