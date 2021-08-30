//
//  LocalizationUtility.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import Foundation

final class LocalizationUtility {
    class func getRegionCode() -> String {
        return Locale.current.regionCode ?? "us"
    }
    
    class func getLanguageCode() -> String {
        return Locale.current.languageCode ?? "en"
    }
    
    class func getTimeZoneIdentifier() -> String {
        return TimeZone.current.identifier
    }
}
