//
//  PaginationModel.swift
//  NewsAPI
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import Foundation

public struct PaginationModel<T: Decodable>: Decodable {
    private(set) var itemCount: Int = 0
    private(set) var items = [T]()
    
    private(set) var page: Int = 1
    var pageCount: Int {
        get {
            return Int(ceil(Double(itemCount) / Double(APIService.shared.API_PAGE_LIMIT)))
        }
    }
    
    private(set) var isPaginating = false
    private(set) var isDonePaginating = false
    
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
