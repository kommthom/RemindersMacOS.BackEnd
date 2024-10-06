//
//  Application+Repositories.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import Fluent

extension Application {
    public struct Repositories {
        public struct Provider {
            public static var database: Self {
                .init {
                    $0.repositories.use { DatabaseCountryRepository(database: $0.db) }
                    $0.repositories.use { DatabaseLocationRepository(database: $0.db) }
                    $0.repositories.use { DatabaseLocaleRepository(database: $0.db) }
                    $0.repositories.use { DatabaseLanguageRepository(database: $0.db) }
                    $0.repositories.use { DatabaseProjectRepository(database: $0.db) }
                    $0.repositories.use { DatabaseTagRepository(database: $0.db) }
                    $0.repositories.use { DatabaseRepetitionRepository(database: $0.db) }
                    $0.repositories.use { DatabaseTaskRepository(database: $0.db) }
                    $0.repositories.use { DatabaseAttachmentRepository(database: $0.db) }
                    $0.repositories.use { DatabaseUploadRepository(database: $0.db) }
                    $0.repositories.use { DatabaseRuleRepository(database: $0.db) }
                    $0.repositories.use { DatabaseHistoryRepository(database: $0.db) }
                    $0.repositories.use { DatabaseUserRepository(database: $0.db) }
                    $0.repositories.use { DatabaseEmailTokenRepository(database: $0.db) }
                    $0.repositories.use { DatabaseRefreshTokenRepository(database: $0.db) }
                    $0.repositories.use { DatabasePasswordTokenRepository(database: $0.db) }
                    $0.repositories.use { DatabaseUserSettingRepository(database: $0.db) }
                    $0.repositories.use { DatabaseTimePeriodRepository(database: $0.db) }
                    $0.repositories.use { DatabaseLocalizationRepository(database: $0.db) }
                }
            }
            public let run: (Application) -> ()
        }
        
        public final class Storage {
            public var makeCountryRepository: ((Application) -> CountryRepositoryProtocol)?
            public var makeLocationRepository: ((Application) -> LocationRepositoryProtocol)?
            public var makeLocaleRepository: ((Application) -> LocaleRepositoryProtocol)?
            public var makeLanguageRepository: ((Application) -> LanguageRepositoryProtocol)?
            public var makeUserRepository: ((Application) -> UserRepositoryProtocol)?
            public var makeEmailTokenRepository: ((Application) -> EmailTokenRepositoryProtocol)?
            public var makeRefreshTokenRepository: ((Application) -> RefreshTokenRepositoryProtocol)?
            public var makePasswordTokenRepository: ((Application) -> PasswordTokenRepositoryProtocol)?
            public var makeProjectRepository: ((Application) -> ProjectRepositoryProtocol)?
            public var makeTagRepository: ((Application) -> TagRepositoryProtocol)?
            public var makeHistoryRepository: ((Application) -> HistoryRepositoryProtocol)?
            public var makeRepetitionRepository: ((Application) -> RepetitionRepositoryProtocol)?
            public var makeTaskRepository: ((Application) -> TaskRepositoryProtocol)?
            public var makeAttachmentRepository: ((Application) -> AttachmentRepositoryProtocol)?
            public var makeUploadRepository: ((Application) -> UploadRepositoryProtocol)?
            public var makeRuleRepository: ((Application) -> RuleRepositoryProtocol)?
            public var makeSettingRepository: ((Application) -> UserSettingRepositoryProtocol)?
            public var makeTimePeriodRepository: ((Application) -> TimePeriodRepositoryProtocol)?
            public var makeLocalizationRepository: ((Application) -> LocalizationRepositoryProtocol)?
            public init() { }
        }
        
        public struct Key: StorageKey {
            public typealias Value = Storage
        }
        
        public let app: Application
        
        public func use(_ provider: Provider) {
            provider.run(app)
        }
        
        public var storage: Storage {
            if app.storage[Key.self] == nil {
                app.storage[Key.self] = .init()
            }
            return app.storage[Key.self]!
        }
    }
    
    public var repositories: Repositories {
        .init(app: self)
    }
}
