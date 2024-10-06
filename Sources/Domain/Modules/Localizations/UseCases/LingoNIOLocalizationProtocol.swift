//
//  LingoNIOLocalizationProtocol.swift
//  
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import DTO

public protocol LingoNIOLocalizationProtocol: ApplicationServiceProtocol {
    func localize(_ key: Localizations.LocalizationKey, locale: Localizations.LocalizationIdentifier, interpolations: [String: Any]?) -> String
    func appendNew(_ key: Localizations.LocalizationKey, locale: Localizations.LocalizationIdentifier, value: Localizations.LocalizationValue) -> Future<Void>
}
