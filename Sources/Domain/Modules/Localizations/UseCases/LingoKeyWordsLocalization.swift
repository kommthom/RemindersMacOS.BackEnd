//
//  LingoKeyWordsLocalization.swift
//
//
//  Created by Thomas Benninghaus on 15.05.24.
//

import Vapor
import DTO

public final class LingoKeyWordsLocalization: LingoKeyWordsLocalizationProtocol, DataSourceLocalizationProtocol {
    
    private let defaultLocale: KeyWords.LocalizationIdentifier
    public let dataSource: NIOLocalizationDataSourceProtocol
    
    private let model: KeyWords
    
    /// Convenience initializer for Lingo.
    ///
    /// - `rootPath` should contain localization files in JSON format
    /// named based on relevant locale. For example: en.json, de.json etc.
    public init(dataSource: NIOLocalizationDataSourceProtocol, defaultLocale: KeyWords.LocalizationIdentifier) {
        self.dataSource = dataSource
        self.defaultLocale = defaultLocale
        self.model = KeyWords()
        
        let validator = LocaleValidator()

        let _ = dataSource.availableLocales()
            .map {
                $0.map { locale in
                    // Check if locale is valid. Invalid locales will not cause any problems in the runtime,
                    // so this validation should only warn about potential mistype in locale names.
                    if !validator.validate(locale: locale) {
                        print("WARNING: Invalid locale identifier: \(locale)")
                    }
                    return dataSource
                        .localizations(forLocale: locale)
                        .map { localizations in
                            self.model.addLocalizations(localizations, for: locale)
                        }
                }
            }
    }
    
    /// Returns localized string for the given key in the requested locale.
    /// If string contains interpolations, they are replaced from the `interpolations` dictionary.
    public func localize(_ key: KeyWords.LocalizationKey, locale: KeyWords.LocalizationIdentifier, interpolations: [String: Any]? = nil) -> String {
        let result = self.model.localize(key, locale: locale, interpolations: interpolations)
        switch result {
            case .success(let localizedString):
                return localizedString
            case .missingKey:
                print("No localizations found for key: \(key), locale: \(locale). Will fallback to raw value of the key.")
                return key.description
            case .missingLocale:
                /// If exact locale is not found (exact meaning that both language and country match),
                /// and the locale has a country code, fall back to matching only by a language code.
            if locale.hasCountryCode {
                let languageCodeResult = self.model.localize(key, locale: locale, interpolations: interpolations)
                if case LocalizationResult.success(let localizationResult) = languageCodeResult {
                        return localizationResult
                    }
                }
                /// Fall back to default locale
                let defaultLocaleResult = self.model.localize(key, locale: self.defaultLocale, interpolations: interpolations)
                if case LocalizationResult.success(let localizationResult) = defaultLocaleResult {
                    return localizationResult
                }
                print("Missing localization for key: \(key), locale: \(locale). Will fallback to raw value of the key.")
                return key.description
        }
    }
 
    /// Returns a list of all available PluralCategories for locale
    public static func availablePluralCategories(forLocale locale: KeyWords.LocalizationIdentifier) -> [PluralCategory] {
        return PluralizationRuleStore.availablePluralCategories(forLocale: locale)
    }
}

extension Application.Localizations {
    public var keyWordLocalization: LingoKeyWordsLocalizationProtocol {
        guard let storage = storage.makeKeyWordsLocalization else {
            fatalError("Lingo Localization not configured, use: app.lingoNIOLocalization.use()")
        }
        return storage(app)
    }
    
    public func use(_ make: @escaping (Application) -> (LingoKeyWordsLocalizationProtocol)) {
        storage.makeKeyWordsLocalization = make
    }
}
