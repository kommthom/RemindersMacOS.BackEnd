//
//  CreateNotification.swift
//
//
//  Created by Thomas Benninghaus on 25.05.24.
//

import Fluent
import DTO

public struct CreateNotification: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        database.createEnum("notificationtype", allCases: NotificationType.allCases.compactMap { $0.rawValue } )
            .flatMap { notificationtype in
                return database.createEnum("historytype", allCases: HistoryType.allCases.compactMap { $0.rawValue } )
                    .flatMap { historytype in
                        return database.schema("notifications").ignoreExisting()
                            .id()
                            .field("duedate", .date, .required)
                            .field("notificationtype", notificationtype, .required)
                            .field("historytype", historytype, .required)
                            .field("deleted_at", .datetime)
                            .field("task_id", .uuid, .required, .references("tasks", "id", onDelete: .cascade))
                            .unique(on: "task_id", "duedate", name: "altkey")
                            .create()
                    }
            }
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("notifications").delete()
    }
}
