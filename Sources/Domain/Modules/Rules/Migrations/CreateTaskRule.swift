//
//  CreateTaskRule.swift
//
//
//  Created by Thomas Benninghaus on 23.01.24.
//

import Fluent

public struct CreateTaskRule: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        return database.schema("taskrules").ignoreExisting()
            .id()
            .field("args", .array(of: .string))
            .field("task_id", .uuid, .required, .references("tasks", "id", onDelete: .cascade))
            .field("rulemodel_id", .uuid, .required, .references("rules", "id", onDelete: .cascade))
            .create()
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("taskrules").delete()
    }
}
