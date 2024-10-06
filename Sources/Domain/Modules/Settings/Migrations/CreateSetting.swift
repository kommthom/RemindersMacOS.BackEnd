//
//  CreateSetting.swift
//
//
//  Created by Thomas Benninghaus on 30.01.24.
//

import Fluent
import DTO

public struct CreateSetting: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        return database.createEnum("scopetype", allCases: ScopeType.allCases.compactMap { $0.rawValue } )
            .flatMap { scopetype in
                return database.createEnum("settingvaluetype", allCases: SettingValueType.allCases.compactMap { $0.rawValue } )
                    .flatMap { settingvaluetype in
                        return database.schema("settings").ignoreExisting()
                            .id()
                            .field("sortorder", .int, .required)
                            .field("scope", scopetype, .required)
                            .field("name", .string, .required)
                            .field("description", .string, .required)
                            .field("image", .string)
                            .field("valuetype", settingvaluetype, .required)
                            .field("boolvalue", .bool)
                            .field("intvalue", .int)
                            .field("stringvalue", .string)
                            .field("idvalue", .uuid)
                            .field("jsonvalue", .string)
                            .field("deleted_at", .datetime)
                            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
                            .unique(on: "user_id", "scope", "name", "deleted_at", name: "key")
                            .create()
                            }
            }
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("settings").delete()
    }
}
