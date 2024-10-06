//
//  CreateUser.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Fluent
import DTO

public struct CreateUser: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        return database.createEnum("locale", allCases: LocaleIdentifier.allCases.compactMap { $0.rawValue } )
            .flatMap { locale in
                return database.schema("users").ignoreExisting()
                    .id()
                    .field("full_name", .string, .required)
                    .field("email", .string, .required)
                    .field("image_url", .string)
                    .field("password_hash", .string, .required)
                    .field("is_admin", .bool, .required, .custom("DEFAULT FALSE"))
                    .field("is_email_verified", .bool, .required, .custom("DEFAULT FALSE"))
                    .field("locale", locale, .required)
                    .field("deleted_at", .datetime)
                    .unique(on: "email", "deleted_at")
                    .create()
            }
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("users").delete()
    }
}
