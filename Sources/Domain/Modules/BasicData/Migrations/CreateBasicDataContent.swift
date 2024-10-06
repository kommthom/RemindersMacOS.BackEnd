//
//  CreateBasicDataContent.swift
//
//
//  Created by Thomas Benninghaus on 24.05.24.
//

import Foundation
import Fluent
import DTO

public struct CreateBasicDataContent: Migration {
    public init() { }
    public func prepare(on database: Database) -> Future<Void> {
        var data: BasicDataModels = BasicDataModels.mock
        return data
            .countries
            .create(on: database)
            .flatMap {
                data
                    .locations
                    .create(on: database)
            }
            .flatMap {
                data
                    .locales
                    .create(on: database)
            }
            .flatMap {
                data
                    .languages
                    .create(on: database)
            }
            .flatMap {
                data
                    .localizations
                    .create(on: database)
            }
            .flatMap {
                data
                    .user
                    .create(on: database)
            }
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return UserModel
            .query(on: database)
            .filter(\.$email == BasicDataModels.mock.user.email)
            .delete(force: true)
            .flatMap {
                LocationModel
                    .query(on: database)
                    .delete(force: true)
            }
            .flatMap {
                LanguageModel
                    .query(on: database)
                    .delete(force: true)
            }
            .flatMap {
                LocaleModel
                    .query(on: database)
                    .delete(force: true)
            }
            .flatMap {
                LocationModel
                    .query(on: database)
                    .delete(force: true)
            }
            .flatMap {
                CountryModel
                    .query(on: database)
                    .delete(force: true)
            }
    }
}
