//
//  UserLocalization.swift
//
//
//  Created by Thomas Benninghaus on 24.05.24.
//

import Vapor
import DTO

public final class UserLocalization: UserLocalizationProtocol {
    public var localization: LingoNIOLocalizationProtocol
    
    public init(localization: LingoNIOLocalizationProtocol) {
        self.localization = localization
    }
    
    public func getAuthenticatedUser(_ req: Vapor.Request) -> AuthenticatedUser {
        req.auth.get(AuthenticatedUser.self) ?? AuthenticatedUser(model: BasicDataModels.mock.user)
    }
    
    public func localize(_ key: Localizations.LocalizationKey, interpolations: [String : Any]?, req: Vapor.Request) -> String {
        let authenticatedUser = getAuthenticatedUser(req)
        let returnValue = localization.localize(key, locale: authenticatedUser.locale.description, interpolations: interpolations)
        if returnValue == key {
            return localization.localize(key, locale: authenticatedUser.email, interpolations: interpolations)
        } else { return returnValue }
    }
    
    public func appendNew(_ key: Localizations.LocalizationKey, value: Localizations.LocalizationValue, req: Vapor.Request) -> Future<Void> {
        let authenticatedUser = getAuthenticatedUser(req)
        return self.localization.appendNew(key, locale: authenticatedUser.email, value: value)
    }
}

extension Application.Localizations {
    public var userLocalization: UserLocalizationProtocol {
        guard let storage = storage.makeUserLocalization else { fatalError("User Localization not configured, use: app.userLocalization.use()") }
        return storage(app)
    }
    
    public func use(_ make: @escaping (Application) -> (UserLocalizationProtocol)) {
        storage.makeUserLocalization = make
    }
}
