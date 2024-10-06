//
//  CreateLocale.swift
//
//
//  Created by Thomas Benninghaus on 16.05.24.
//

import Fluent
import DTO

public struct CreateLocale: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        database.createEnum("localeidentifier", allCases: LocaleIdentifier.allCases.compactMap { $0.description } )
            .flatMap { localeIdentifier in
                return database.createEnum("timeseparator", allCases: DateRelative.FormatStyle.TimeSeparator.allCases.compactMap { $0.rawValue } )
                    .flatMap { timeSeparator in
                        return database.createEnum("timezoneseparator", allCases: DateRelative.FormatStyle.TimeZoneSeparator.allCases.compactMap { $0.rawValue } )
                            .flatMap { timezoneseparator in
                                return database.createEnum("dateseparator", allCases: DateRelative.FormatStyle.DateSeparator.allCases.compactMap { $0.rawValue } )
                                    .flatMap { dateseparator in
                                        return database.createEnum("datetimeseparator", allCases: DateRelative.FormatStyle.DateTimeSeparator.allCases.compactMap { $0.rawValue } )
                                            .flatMap { datetimeseparator in
                                                return database.schema("locales").ignoreExisting()
                                                    .id()
                                                    .field("name", .string, .required)
                                                    .field("identifier", localeIdentifier)
                                                    .field("longname", .string, .required)
                                                    .field("timefirst", .bool, .required)
                                                    .field("timeseparator", timeSeparator)
                                                    .field("timezoneseparator", timezoneseparator)
                                                    .field("dateseparator", dateseparator)
                                                    .field("datetimeseparator", datetimeseparator)
                                                    .field("timeformatstring", .string, .required)
                                                    .field("standarddateformatstring", .string, .required)
                                                    .field("dateformatstring", .string, .required)
                                                    .field("language_id", .uuid, .references("languages", "id", onDelete: .cascade))
                                                    .unique(on: "identifier", name: "altkey")
                                                    .create()
                                            }
                                    }
                            }
                    }
            }
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("locales").delete()
    }
}
