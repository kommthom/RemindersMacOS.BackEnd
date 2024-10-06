//
//  NIOLocalizationDataSourceProtocol.swift
//
//
//  Created by Thomas Benninghaus on 13.05.24.
//

import Vapor
import DTO

/// Types conforming to this protocol can be used to initialize Lingo.
///
/// Use it in case your localizations are not stored in JSON files, but rather in a database or other storage technology.
public protocol NIOLocalizationDataSourceProtocol {
    
    /// Return a list of available locales.
    /// Lingo will query for localizations for each of these locales in localizations(for:) method.
    func availableLocales() -> Future<[Localizations.LocalizationIdentifier]>
    
    /// Return localizations for a given locale.
    func localizations(forLocale locale: Localizations.LocalizationIdentifier) -> Future<[Localizations.LocalizationKey: Localizations.LocalizationValue]>
    func localizations(forLocale locale: KeyWords.LocaleIdentifier) -> Future<[KeyWords.LocalizationKey: KeyWords.LocalizationValue]>
    
    //// Append value for a given localization and key
    func appendLocalization(forLocale locale: Localizations.LocalizationIdentifier, localizationKey: Localizations.LocalizationKey, value: Localizations.LocalizationValue) -> Future<Void>
}
