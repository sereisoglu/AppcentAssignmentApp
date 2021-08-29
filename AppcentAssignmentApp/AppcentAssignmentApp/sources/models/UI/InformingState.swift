//
//  InformingState.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import Foundation

enum InformingState: Equatable {
    case data
    case emptyOrError(headerText: String, messageText: String)
    case loading
}
