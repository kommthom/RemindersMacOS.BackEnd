//
//  CreateRule.swift
//  
//
//  Created by Thomas Benninghaus on 23.01.24.
//

import Fluent
import DTO

public struct CreateRule: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        return database.createEnum("ruletype", allCases: RuleType.allCases.compactMap { $0.rawValue } )
            .flatMap { ruletype in
                return database.createEnum("actiontype", allCases: ActionType.allCases.compactMap { $0.rawValue } )
                    .flatMap { actiontype in
                        return database.schema("rules").ignoreExisting()
                            .id()
                            .field("description", .string, .required)
                            .field("ruletype", ruletype, .required)
                            .field("actiontype", actiontype, .required)
                            .field("args", .array(of: .string))
                            .field("deleted_at", .datetime)
                            .create()
                    }
            }
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("rules").delete()
    }
}
