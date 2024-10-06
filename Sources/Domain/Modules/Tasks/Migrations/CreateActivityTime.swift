//
//  CreateActivityTime.swift
//
//
//  Created by Thomas Benninghaus on 25.05.24.
//

import Fluent
import DTO

public struct CreateActivityTime: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        return database.schema("activitytimes").ignoreExisting()
            .id()
            .field("startingtime", .time, .required)
            .field("timeactive", .float, .required)
            .field("deleted_at", .datetime)
            .field("task_id", .uuid, .required, .references("tasks", "id", onDelete: .cascade))
            .unique(on: "task_id")
            .create()
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("activitytimes").delete()
    }
}
