//
//  CreateCountryLocale.swift
//
//
//  Created by Thomas Benninghaus on 16.05.24.
//

import Fluent

public struct CreateCountryLocale: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        return database.schema("countrylocales").ignoreExisting()
            .id()
            .field("country_id", .uuid, .required, .references("countries", "id", onDelete: .cascade))
            .field("locale_id", .uuid, .required, .references("locales", "id", onDelete: .cascade))
            .create()
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("countrylocales").delete()
    }
}
