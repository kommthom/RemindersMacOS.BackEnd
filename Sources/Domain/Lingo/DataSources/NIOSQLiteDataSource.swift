//
//  NIOSQLiteDataSource.swift
//  
//
//  Created by Thomas Benninghaus on 13.05.24.
//

import Vapor
import DTO

/// Class providing file backed data source for Lingo in case localizations are stored in SQLite database.
public final class NIOSQLiteDataSource: NIOLocalizationDataSourceProtocol {
    private var repository: LocalizationRepositoryProtocol
    
    public init(repository: LocalizationRepositoryProtocol) {
        self.repository = repository
    }
    
    public func availableLocales() -> Future<[Localizations.LocalizationIdentifier]> {
        repository
            .allLocales()
    }
    
    public func localizations(forLocale locale: Localizations.LocalizationIdentifier) -> Future<[Localizations.LocalizationKey: Localization]> {
        return repository
            .all(locale: locale) //Future<[LocalizationModel]>
            .map { localizations in
                return localizations
                    .map { localization in
                        if let stringValue = localization.value {
                            return (localization.key, Localization.universal(value: stringValue))
                        } else {
                            return (localization.key, Localization.pluralized(values: self.pluralizedValues(fromRaw: localization.pluralized ?? [:])))
                        }
                    }
            }
            .map { localizationPairs in
                return Dictionary(localizationPairs, uniquingKeysWith: { (key, _) in key })
            }
    }
    
    public func localizations(forLocale locale: KeyWords.LocaleIdentifier) -> Future<[KeyWords.LocalizationKey: CompositeString]> {
        return self.repository
            .allKeyWords() //Future<[LocalizationModel]>
            .map { localizations in
                return localizations
                    .compactMap { localization in
                        if let stringValue = localization.value {
                            return (KeyWord(rawValue: localization.enumKey!)!, CompositeString(rawValue: stringValue)!)
                        }
                        return nil
                    }
            }
            .map { localizationPairs in
                return Dictionary(localizationPairs, uniquingKeysWith: { (key, _) in key })
            }
    }
    
    public func appendLocalization(forLocale locale: Localizations.LocalizationIdentifier, localizationKey: Localizations.LocalizationKey, value: Localization) -> Future<Void> {
        return self.repository
            .find(userName: locale, locale: locale, key: localizationKey)
            .flatMap { localization in
                switch value {
                case Localization.universal(value: let localizationValue):
                    if let _ = localization {
                        return self.repository
                            .set(\.$value, to: localizationValue, for: localization!.id!)
                    }
                    return self.repository
                        .create(LocalizationModel(id: UUID(), languageModel: .localizations, languageCode: locale, enumKey: nil, key: localizationKey, value: localizationValue))
                case .pluralized(values: let pluralizedValues):
                    let pluralizedDict = Dictionary(pluralizedValues
                        .map { (pluralizedCategory, stringValue) in
                            return (pluralizedCategory.rawValue, stringValue)
                                },
                        uniquingKeysWith: { (key, _) in key })
                    if let localizationNotNil = localization {
                        return self.repository
                            .set(LocalizationModel(id: localizationNotNil.id!, languageModel: localizationNotNil.languageModel, languageCode: localizationNotNil.languageCode, enumKey: nil, key: localizationNotNil.key, value: nil, pluralized: pluralizedDict))
                    }
                    return self.repository
                        .create(LocalizationModel(id: UUID(), languageModel: .localizations, languageCode: locale, enumKey: nil, key: localizationKey, value: nil, pluralized: pluralizedDict))
                }
            }
    }
}

private extension NIOSQLiteDataSource {
    /// Parses a dictionary which has string plural categories as keys ([String: String]) and returns a typed dictionary ([PluralCategory: String])
    /// An example dictionary looks like:
    /// {
    ///   "one": "You have an unread message."
    ///   "many": "You have %{count} unread messages."
    /// }
    func pluralizedValues(fromRaw rawPluralizedValues: [String: String]) -> [PluralCategory: String] {
        var result = [PluralCategory: String]()
        
        for (rawPluralCategory, value) in rawPluralizedValues {
            if let pluralCategory = PluralCategory(rawValue: rawPluralCategory) {
                result[pluralCategory] = value
            } else { print("Unsupported plural category: \(rawPluralCategory)") }
        }
        return result
    }
}

