//
//  LingoKeyWordsLocalizationProtocol.swift
//
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import DTO

public protocol LingoKeyWordsLocalizationProtocol: ApplicationServiceProtocol {
    init(dataSource: NIOLocalizationDataSourceProtocol, defaultLocale: KeyWords.LocalizationIdentifier)
    func localize(_ key: KeyWords.LocalizationKey, locale: KeyWords.LocalizationIdentifier, interpolations: [String: Any]?) -> String
    static func availablePluralCategories(forLocale locale: KeyWords.LocalizationIdentifier) -> [PluralCategory]
}
