//
//  CreateLocation.swift
//
//
//  Created by Thomas Benninghaus on 16.05.24.
//

import Fluent
import DTO

public struct CreateLocation: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        return database.schema("locations").ignoreExisting()
            .id()
            .field("description", .string, .required)
            .field("identifier", .string, .required)
            .field("timezone", .string, .required)
            .field("country_id", .uuid, .references("countries", "id", onDelete: .cascade))
            .unique(on: "identifier", name: "altkey")
            .create()
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("locations").delete()
    }
}
