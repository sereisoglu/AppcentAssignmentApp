//
//  PaginationModel.swift
//  NewsAPI
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import Foundation

public struct PaginationModel<T: Decodable>: Decodable {
    public private(set) var itemCount: Int = 0
    public private(set) var items = [T]()
    
    public private(set) var page: Int = 1
    public var pageCount: Int {
        get {
            return Int(ceil(Double(itemCount) / Double(NewsAPI.shared.API_PAGE_LIMIT)))
        }
    }
    
    public private(set) var isPaginating = false
    public private(set) var isDonePaginating = false
    
    enum CodingKeys: String, CodingKey {
        case itemCount = "totalResults"
        case items = "articles"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        itemCount = try values.decode(Int?.self, forKey: .itemCount) ?? 0
        items = try values.decode([T]?.self, forKey: .items) ?? []
    }
    
    public mutating func increasePage() {
        page += 1
    }
    
    public mutating func setIsPaginating(isPaginating: Bool) {
        self.isPaginating = isPaginating
    }
    
    public mutating func appendItems(items: [T]?) {
        guard let items = items,
              !items.isEmpty else {
            isDonePaginating = true
            
            return
        }
        
        if pageCount == page {
            isDonePaginating = true
        }
        
        self.items.append(contentsOf: items)
    }
}
