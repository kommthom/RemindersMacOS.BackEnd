//
//  CreateRefreshToken.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Fluent

public struct CreateRefreshToken: Migration {
    public  init() { }
    public func prepare(on database: Database) -> Future<Void> {
        return database.schema("user_refresh_tokens").ignoreExisting()
            .id()
            .field("token", .string)
            .field("user_id", .uuid, .references("users", "id", onDelete: .cascade))
            .field("expires_at", .datetime)
            .field("issued_at", .datetime)
            .unique(on: "token")
            .unique(on: "user_id")
            .create()
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("user_refresh_tokens").delete()
    }
}
