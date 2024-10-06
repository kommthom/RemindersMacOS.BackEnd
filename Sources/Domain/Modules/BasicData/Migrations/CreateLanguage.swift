//
//  CreateLanguage.swift
//  
//
//  Created by Thomas Benninghaus on 16.05.24.
//

import Fluent
import DTO

public struct CreateLanguage: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        database.createEnum("languageidentifier", allCases: LanguageIdentifier.allCases.compactMap { $0.description } )
            .flatMap { languageIdentifier in
                return database.schema("languages").ignoreExisting()
                    .id()
                    .field("name", .string, .required)
                    .field("identifier", languageIdentifier)
                    .field("longname", .string, .required)
                    .unique(on: "identifier", name: "altkey")
                    .create()
            }
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("languages").delete()
    }
}
