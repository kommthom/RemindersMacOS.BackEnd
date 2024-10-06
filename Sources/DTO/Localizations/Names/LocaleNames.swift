//
//  LocaleNames.swift
//
//
//  Created by Thomas Benninghaus on 21.05.24.
//

import Foundation

public struct LocaleNames: LocaleNamesProtocol {
    public var locale: LocaleIdentifier
    
    public init(locale: LocaleIdentifier) {
        self.locale = locale
    }
}
