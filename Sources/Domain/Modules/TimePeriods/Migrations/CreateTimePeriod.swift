//
//  CreateTimePeriod.swift
//
//
//  Created by Thomas Benninghaus on 22.01.24.
//

import Fluent
import DTO

public struct CreateTimePeriod: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        return database.createEnum("typeoftime", allCases: TypeOfTime.allCases.compactMap { $0.rawValue } )
            .flatMap { typeoftime in
                return database.schema("timeperiods").ignoreExisting()
                    .id()
                    .field("typeoftime", typeoftime)
                    .field("from", .string, .required)
                    .field("to", .string, .required)
                    .field("day", .date)
                    .field("deleted_at", .datetime)
                    .field("parent_id", .uuid, .references("timeperiods", "id", onDelete: .cascade))
                    .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
                    .unique(on: "user_id", "typeoftime", "day", "from", name: "key")
                    .create()
            }
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("timeperiods").delete()
    }
}
