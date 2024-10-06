//
//  KeyWords.swift
//
//
//  Created by Thomas Benninghaus on 13.05.24.
//

import Foundation

public final class KeyWords {
    public typealias LocalizationKey = KeyWord
    public typealias LocalizationValue = CompositeString
    public typealias LocalizationIdentifier = String
    
    private var data = [LocalizationIdentifier: [LocalizationKey: LocalizationValue]]()
    
    private static func filter(localeBucket: [LocalizationKey: LocalizationValue], matching predicate: Predicate<CompositeStringDictionaryElement>) -> [LocalizationKey: LocalizationValue] {
        localeBucket.filter(predicate.matches)
    }
    
    private static func firstKey(localeBucket: [LocalizationKey: LocalizationValue], matching predicate: Predicate<CompositeStringDictionaryElement>) -> LocalizationKey? {
        localeBucket.first(where: predicate.matches)?.key
    }
    
    public init(data: [LocalizationIdentifier: [LocalizationKey: LocalizationValue]]) {
        self.data = data
    }
    
    public init(keyWords: [LocalizationKey] = KeyWord.AllCases()) {
        self.data[LocaleIdentifier.notSet.description] = Dictionary(uniqueKeysWithValues: keyWords.lazy.map { ($0, LocalizationValue(rawValue: $0.description)!) })
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
    
    /// Returns localized string of a given key in the given locale.
    /// If string contains interpolations, they are replaced from the dictionary.
    public func localize(_ key: LocalizationKey, locale: LocalizationIdentifier, interpolations: [String: Any]? = nil) -> LocalizationResult {
        guard let localeBucket = self.data[locale] else { return .missingLocale }
        guard let localization = localeBucket[key] else { return .missingKey }
        return .success(localization: localization.rawValue)
    }
    
    public func findTranslatedKeyWord(locale: LocalizationIdentifier = LanguageIdentifier.notSet.description, rawValue: String) -> LocalizationKey? {
        let lowerCasedValue = rawValue.lowercased()
        let filtered = KeyWords.filter(localeBucket: self.data[locale]!, matching: .hasPrefix(comparedTo: lowerCasedValue))
        guard !filtered.isEmpty else { return nil }
        if locale == LanguageIdentifier.notSet.description && filtered.count == 1 { return filtered.first!.key }
        return KeyWords.firstKey(localeBucket: filtered, matching: .hasSuffix(comparedTo: lowerCasedValue))
    }
}
