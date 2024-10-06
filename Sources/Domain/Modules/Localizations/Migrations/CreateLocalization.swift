//
//  CreateLocalization.swift
//
//
//  Created by Thomas Benninghaus on 13.05.24.
//

import Foundation
import Fluent
import DTO

public struct CreateLocalization: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        database.createEnum("modeltype", allCases: ModelTypes().localizationModels.compactMap { $0.rawValue } )
            .flatMap { modelType in
                return database.schema("localizations").ignoreExisting()
                    .id()
                    .field("languagemodel", modelType, .required)
                    .field("languagecode", .string, .required)
                    .field("enum", .int)
                    .field("key", .string, .required)
                    .field("value", .string)
                    .field("pluralized", .dictionary(of: .string))
                    .field("deleted_at", .datetime)
                    .unique(on: "languagecode", "enum", "key", name: "altkey")
                    .create()
            }
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("localizations").delete()
    }
}
