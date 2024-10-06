//
//  CreateRepetition.swift
//  
//
//  Created by Thomas Benninghaus on 22.01.24.
//

import Fluent
import DTO

public struct CreateRepetition: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        database.createEnum("notificationtype", allCases: NotificationType.allCases.compactMap { $0.rawValue } )
            .flatMap { notificationtype in
                return database.schema("repetitions").ignoreExisting()
                    .id()
                    .field("iteration", .int, .required)
                    .field("duedate", .date, .required)
                    .field("fromdone", .bool, .required)
                    .field("repetitionnumber", .int, .required)
                    .field("repetitionjson", .string)
                    .field("repetitionend", .date)
                    .field("maxiterations", .int)
                    .field("repetitiontext", .string, .required)
                    .field("notification", notificationtype)
                    .field("deleted_at", .datetime)
                    .field("task_id", .uuid, .required, .references("tasks", "id", onDelete: .cascade))
                    .unique(on: "task_id")
                    .create()
            }
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("repetitions").delete()
    }
}
