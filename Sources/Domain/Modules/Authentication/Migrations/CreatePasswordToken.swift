//
//  CreatePasswordToken.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Fluent

public struct CreatePasswordToken: Migration {
    public  init() { }
    public func prepare(on database: Database) -> Future<Void> {
        database.schema("user_password_tokens").ignoreExisting()
            .id()
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("token", .string, .required)
            .field("expires_at", .datetime, .required)
            .create()
    }
    
    public func revert(on database: Database) -> Future<Void> {
        database.schema("user_password_tokens").delete()
    }
}
