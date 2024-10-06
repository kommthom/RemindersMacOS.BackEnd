//
//  CreateHistory.swift
//
//
//  Created by Thomas Benninghaus on 23.01.24.
//

import Fluent
import DTO

public struct CreateHistory: Migration {
    public init() { }

    public func prepare(on database: Database) -> Future<Void> {
        return database.createEnum("historytype", allCases: HistoryType.allCases.compactMap { $0.rawValue } )
            .flatMap { historytype in
                return database.schema("history").ignoreExisting()
                    .id()
                    .field("timestamp", .datetime, .required)
                    .field("historytype", historytype)
                    .field("deleted_at", .datetime)
                    .field("task_id", .uuid, .required, .references("tasks", "id", onDelete: .cascade))
                    .create()
            }
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("history").delete()
    }
}
