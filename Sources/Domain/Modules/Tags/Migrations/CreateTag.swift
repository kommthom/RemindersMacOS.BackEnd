//
//  CreateTag.swift
//  
//
//  Created by Thomas Benninghaus on 22.01.24.
//

import Fluent

public struct CreateTag: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        return database.schema("tags").ignoreExisting()
            .id()
            .field("description", .string, .required)
            .field("color", .data)
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("deleted_at", .datetime)
            .unique(on: "user_id", "description", "deleted_at", name: "key")
            .create()
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("tags").delete()
    }
}
