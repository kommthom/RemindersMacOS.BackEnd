//
//  UserLocalizationProtocol.swift
//
//
//  Created by Thomas Benninghaus on 24.05.24.
//

import Vapor
import DTO

public protocol UserLocalizationProtocol: LocalizationServiceProtocol {
    func getAuthenticatedUser(_ req: Request) -> AuthenticatedUser
    func localize(_ key: Localizations.LocalizationKey, interpolations: [String: Any]?, req: Request) -> String
    func appendNew(_ key: Localizations.LocalizationKey, value: Localizations.LocalizationValue, req: Vapor.Request) -> Future<Void>
}
