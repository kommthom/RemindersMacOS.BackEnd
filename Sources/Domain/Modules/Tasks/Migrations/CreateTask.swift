//
//  CreateTask.swift
//
//
//  Created by Thomas Benninghaus on 28.12.23.
//

import Fluent
import DTO

public struct CreateTask: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        return database.createEnum("prioritymodel", allCases: PriorityModel.allCases.compactMap { $0.rawValue } )
            .flatMap { prioritymodel in
                database.createEnum("notificationtype", allCases: NotificationType.allCases.compactMap { $0.rawValue } )
                    .flatMap { notificationtype in
                        return database.schema("tasks").ignoreExisting()
                            .id()
                            .field("description", .string, .required)
                            .field("title", .string, .required)
                            .field("iscompleted", .bool, .required)
                            .field("homepage", .string)
                            .field("dutypoints", .int)
                            .field("funpoints", .int)
                            .field("duration", .float)
                            .field("iscalendar", .bool, .required)
                            .field("breakafter", .float)
                            .field("archivedPath", .string)
                            .field("priority", prioritymodel)
                            .field("notification", notificationtype)
                            .field("deleted_at", .datetime)
                            .field("created_at", .datetime)
                            .field("parenttask_id", .uuid, .references("tasks", "id", onDelete: .cascade))
                            .field("nexttask_id", .uuid, .references("tasks", "id", onDelete: .cascade))
                            .field("history_id", .uuid, .references("history", "id", onDelete: .cascade))
                            .field("project_id", .uuid, .required, .references("projects", "id", onDelete: .cascade))
                            .create()
                    }
            }
    }

    public func revert(on database: Database) -> Future<Void> {
        return database.schema("tasks").delete()
    }
}
