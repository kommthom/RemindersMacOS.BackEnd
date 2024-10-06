//
//  CreateRepetitionTimePeriod.swift
//
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Fluent

public struct CreateRepetitionTimePeriod: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        return database.schema("repetitiontimeperiods").ignoreExisting()
            .id()
            .field("repetition_id", .uuid, .required, .references("repetitions", "id", onDelete: .cascade))
            .field("timeperiodmodel_id", .uuid, .required, .references("timeperiods", "id", onDelete: .cascade))
            .field("deleted_at", .datetime)
            .create()
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("repetitiontimeperiods").delete()
    }
}
