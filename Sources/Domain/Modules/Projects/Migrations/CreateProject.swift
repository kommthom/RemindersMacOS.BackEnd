//
//  CreateProject.swift
//
//
//  Created by Thomas Benninghaus on 28.12.23.
//

import Fluent

public struct CreateProject: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        return database.schema("projects").ignoreExisting()
            .id()
            .field("user_id", .uuid, .references("users", "id", onDelete: .cascade))
            .field("left", .int, .required)
            .field("right", .int, .required)
            .field("name", .string, .required)
            .field("color", .data)
            .field("iscompleted", .bool)
            .field("tagmodel_id", .uuid, .references("tags", "id"))
            .field("level", .int, .required)
            .field("path", .string, .required)
            .field("issystem", .bool, .required)
            .field("deleted_at", .datetime)
            .unique(on: "user_id", "left", "right", "deleted_at", name: "key")
            .create()
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("projects").delete()
    }
}
