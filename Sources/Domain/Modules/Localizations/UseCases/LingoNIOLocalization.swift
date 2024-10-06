//
//  LingoNIOLocalization.swift
//
//
//  Created by Thomas Benninghaus on 13.05.24.
//

import Vapor
import DTO

public final class LingoNIOLocalization: LingoNIOLocalizationProtocol, DataSourceLocalizationProtocol {
    private let defaultLocale: Localizations.LocalizationIdentifier
    public let dataSource: NIOLocalizationDataSourceProtocol
    
    private let model: Localizations
    
    /// Initializes Lingo with a `LocalizationDataSource`.
    /// - `defaultLocale` will be used as a fallback when no localizations are available for a requested locale.
    public init(dataSource: NIOLocalizationDataSourceProtocol, defaultLocale: Localizations.LocalizationIdentifier) {
        self.dataSource = dataSource
        self.defaultLocale = defaultLocale
        self.model = Localizations()
        
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
    public func localize(_ key: Localizations.LocalizationKey, locale: Localizations.LocalizationIdentifier, interpolations: [String: Any]? = nil) -> String {
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
                        if case LocalizationResult.success(let localizationResult) = languageCodeResult { return localizationResult }
                }
                /// Fall back to default locale
                let defaultLocaleResult = self.model.localize(key, locale: self.defaultLocale, interpolations: interpolations)
                if case LocalizationResult.success(let localizationResult) = defaultLocaleResult { return localizationResult }
                print("Missing localization for key: \(key), locale: \(locale). Will fallback to raw value of the key.")
                return key
        }
    }
    
    public func appendNew(_ key: Localizations.LocalizationKey, locale: Localizations.LocalizationIdentifier, value: Localizations.LocalizationValue) -> Future<Void> {
        self.model.addLocalization(key, value: value, for: locale)
        return dataSource.appendLocalization(forLocale: locale, localizationKey: key, value: value)
    }
 
    /// Returns a list of all available PluralCategories for locale
    public static func availablePluralCategories(forLocale locale: Localizations.LocalizationIdentifier) -> [PluralCategory] {
        return PluralizationRuleStore.availablePluralCategories(forLocale: locale)
    }
}

extension Application.Localizations {
    public var lingoLocalization: LingoNIOLocalizationProtocol {
        guard let storage = storage.makeLingoLocalization else { fatalError("Lingo Localization not configured, use: app.lingoNIOLocalization.use()") }
        return storage(app)
    }
    
    public func use(_ make: @escaping (Application) -> (LingoNIOLocalizationProtocol)) {
        storage.makeLingoLocalization = make
    }
}
