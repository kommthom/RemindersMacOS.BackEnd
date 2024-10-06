//
//  LocalizationResult.swift
//
//
//  Created by Thomas Benninghaus on 14.05.24.
//

import Foundation

public enum LocalizationResult {
    case success(localization: String)
    case missingLocale
    case missingKey
}
