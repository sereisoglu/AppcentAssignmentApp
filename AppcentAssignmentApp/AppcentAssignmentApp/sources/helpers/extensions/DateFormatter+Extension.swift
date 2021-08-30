//
//  DateFormatter+Extension.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import Foundation

extension DateFormatter {
    static let formatIso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = DateFormatType.iso8601.rawValue
        return formatter
    }()
    
    static let formatMonthAndDayAndYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = DateFormatType.monthAndDayAndYear.rawValue
        return formatter
    }()
    
    static let formatMonthAndDayAndYearAndDayNameAndTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = DateFormatType.monthAndDayAndYearAndDayNameAndTime.rawValue
        return formatter
    }()
}
