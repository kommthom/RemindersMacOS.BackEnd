//
//  CreateTaskTag.swift
//  
//
//  Created by Thomas Benninghaus on 10.02.24.
//

import Fluent

public struct CreateTaskTag: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        return database.schema("tasktags").ignoreExisting()
            .id()
            .field("task_id", .uuid, .required, .references("tasks", "id", onDelete: .cascade))
            .field("tagmodel_id", .uuid, .required, .references("tags", "id", onDelete: .cascade))
            .field("deleted_at", .datetime)
            .create()
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("tasktags").delete()
    }
}

