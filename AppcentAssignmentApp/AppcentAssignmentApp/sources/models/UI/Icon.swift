//
//  Icon.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit

enum Icon: String {
    case calendar
    case heartFill = "heart-fill"
    case heart
    case newspaperFill = "newspaper-fill"
    case newspaper
    case personFill = "person-fill"
    case photo
    case squareAndArrowUp = "square-and-arrow-up"
    
    var value: UIImage {
        return UIImage(named: "\(rawValue)") ?? UIImage()
    }
}

enum IconSize {
    case pt14
    case pt18
    case pt20
    case pt22
    case pt30
    
    var value: CGSize {
        switch self {
        case .pt14:
            return .equalEdge(14)
        case .pt18:
            return .equalEdge(18)
        case .pt20:
            return .equalEdge(20)
        case .pt22:
            return .equalEdge(22)
        case .pt30:
            return .equalEdge(30)
        }
    }
}
