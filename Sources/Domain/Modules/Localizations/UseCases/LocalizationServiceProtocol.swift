//
//  LocalizationServiceProtocol.swift
//
//
//  Created by Thomas Benninghaus on 24.05.24.
//

import Vapor
import Fluent

public protocol LocalizationServiceProtocol: RequestServiceProtocol, ApplicationServiceProtocol {
    var localization: LingoNIOLocalizationProtocol { get }
    init(localization: LingoNIOLocalizationProtocol)
}

extension LocalizationServiceProtocol {
    public func `for`(_ req: Request) -> Self {
        return Self.init(localization: req.application.localizations.lingoLocalization)
    }
    
    public func `for`(_ app: Application) -> Self {
        return Self.init(localization: app.localizations.lingoLocalization)
    }
}
