//
//  Application+Localizations.swift
//
//
//  Created by Thomas Benninghaus on 15.05.24.
//

import Vapor
import Fluent
import DTO

extension Application {
    public var localizationDS: NIOLocalizationDataSourceProtocol {
        NIOSQLiteDataSource(repository: self.repositories.localizations)
    }

    public struct Localizations {
        public struct Provider {
            public static var localization: Self {
                .init {
                    $0.localizations.use { LingoNIOLocalization(dataSource: $0.localizationDS, defaultLocale: DTOConstants.shared.defaultLocale.description) }
                    $0.localizations.use { LingoKeyWordsLocalization(dataSource: $0.localizationDS, defaultLocale: DTOConstants.shared.defaultLocale.description ) }
                    $0.localizations.use { UserLocalization(localization: $0.localizations.lingoLocalization) }
                }
            }
            public let run: (Application) -> ()
        }
        
        public final class Storage {
            public var makeLingoLocalization: ((Application) -> LingoNIOLocalizationProtocol)?
            public var makeKeyWordsLocalization: ((Application) -> LingoKeyWordsLocalizationProtocol)?
            public var makeUserLocalization: ((Application) -> UserLocalizationProtocol)?
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
    
    public var localizations: Localizations {
        .init(app: self)
    }
}

