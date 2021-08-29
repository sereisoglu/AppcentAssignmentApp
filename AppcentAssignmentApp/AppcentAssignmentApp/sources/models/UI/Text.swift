//
//  Text.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import Foundation

struct Text {
    enum `Type` {
        case `default`
        case underlined
        case medium
        case bold
    }
    
    var type: Type = .default
    var string: String
}
