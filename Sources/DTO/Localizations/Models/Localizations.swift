//
//  Localizations.swift
//  
//
//  Created by Thomas Benninghaus on 13.05.24.
//

import Foundation

public final class Localizations {
    public typealias LocalizationKey = String
    public typealias LocalizationValue = Localization
    public typealias LocalizationIdentifier = String
    
    private var data = [LocalizationIdentifier: [LocalizationKey: Localization]]()
    
    public init(data: [LocalizationIdentifier : [LocalizationKey : Localization]] = [LocalizationIdentifier: [LocalizationKey: LocalizationValue]]()) {
        self.data = data
    }
        
    public func addLocalizations(_ localizations: [LocalizationKey: LocalizationValue], `for` locale: LocalizationIdentifier) {
        // Find existing bucket for a given locale or create a new one
        if var existingLocaleBucket = self.data[locale] {
            for (localizationKey, localization) in localizations {
                existingLocaleBucket[localizationKey] = localization
                self.data[locale] = existingLocaleBucket
            }
        } else {
            self.data[locale] = localizations
        }
    }
    
    public func addLocalization(_ key: LocalizationKey, value: LocalizationValue, `for` locale: LocalizationIdentifier) {
        // Find existing bucket for a given locale or create a new one
        if var existingLocaleBucket = self.data[locale] {
            existingLocaleBucket[key] = value
        } else {
            self.data[locale] = [key: value]
        }
    }
    
    /// Returns localized string of a given key in the given locale.
    /// If string contains interpolations, they are replaced from the dictionary.
    public func localize(_ key: LocalizationKey, locale: LocalizationIdentifier, interpolations: [String: Any]? = nil) -> LocalizationResult {
        guard let localeBucket = self.data[locale] else { return .missingLocale }
        guard let localization = localeBucket[key] else { return .missingKey }
        let localizedString = localization.value(forLocale: locale, interpolations: interpolations)
        return .success(localization: localizedString)
    }
}

extension Localizations.LocalizationIdentifier {

    /// Returns `true` if the locale identifier contains both, language and country code
    public var hasCountryCode: Bool {
        return self.components(separatedBy: "-").count == 2
    }

    /// Returns language code from the locale identifier string.
    /// For locales which contains a country code (en-US, de-CH), the country code is removed.
    public var languageCode: String {
        let components = self.components(separatedBy: "-")
        return components.count == 2 ? components.first! : self
    }

}
