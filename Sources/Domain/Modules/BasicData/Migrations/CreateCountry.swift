//
//  CreateCountry.swift
//
//
//  Created by Thomas Benninghaus on 16.05.24.
//

import Fluent
import DTO

public struct CreateCountry: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        return database.schema("countries").ignoreExisting()
            .id()
            .field("description", .string, .required)
            .field("identifier", .string, .required)
            .field("locale_id", .uuid, .references("locales", "id", onDelete: .cascade))
            .unique(on: "identifier", name: "altkey")
            .create()
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("countries").delete()
    }
}
