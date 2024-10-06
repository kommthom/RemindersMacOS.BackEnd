//
//  GroupNameTranslator.swift
//
//
//  Created by Thomas Benninghaus on 08.05.24.
//

import Vapor
import DTO

public struct GroupNameTranslator {
    public var localization: LocalizationProtocol
    public var authenticatedUser: AuthenticatedUser
    
    public init?(localization: LocalizationProtocol, authenticatedUser: AuthenticatedUser?) {
        self.localization = localization
        if let _ = authenticatedUser {
            self.authenticatedUser = authenticatedUser!
        } else { return nil }
    }
    
    public init?(req: Request) throws {
        guard let localization = try? req.application.localization.provide(), let authenticatedUser = req.auth.get(AuthenticatedUser.self) else { return nil }
        self.init(localization: localization, authenticatedUser: authenticatedUser)
    }
    
    public func fromDate(groupDate: Date?) -> String {
        if let _ = groupDate {
            var interpolations: [String: String] = .init()
            interpolations["formattedDate"] = self.authenticatedUser.locale.formatDate(groupDate!)
            interpolations["weekDay"] = self.authenticatedUser.locale.weekDay(groupDate!)
            let key = switch groupDate {
                case Date.today:"tasks.today"
                case Date.tomorrow: "tasks.tomorrow"
                default: "tasks.future"
            }
            return self.localization.localize(key, locale: self.authenticatedUser.locale.locale.identifier, interpolations: interpolations)
        } else {
            return self.localization.localize("tasks.overdue", locale: self.authenticatedUser.locale.locale.identifier, interpolations: nil)
        }
    }
    
    public func fromString(groupName: String) -> String {
        localization.localize(groupName, locale: authenticatedUser.locale.description, interpolations: nil)
    }
}
