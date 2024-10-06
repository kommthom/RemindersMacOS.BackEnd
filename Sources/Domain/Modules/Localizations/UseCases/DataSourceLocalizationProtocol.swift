//
//  DataSourceLocalizationProtocol.swift
//  
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import DTO
import Vapor

public protocol DataSourceLocalizationProtocol: ApplicationServiceProtocol {
    var dataSource: NIOLocalizationDataSourceProtocol { get }
    init(dataSource: NIOLocalizationDataSourceProtocol, defaultLocale: Localizations.LocalizationIdentifier)
}

extension DataSourceLocalizationProtocol {
    public func `for`(_ app: Application) -> Self {
        let dataSource: NIOLocalizationDataSourceProtocol = NIOSQLiteDataSource(repository: app.repositories.localizations)
        return Self.init(dataSource: dataSource, defaultLocale: DTOConstants.shared.defaultLocale.description)
    }
}
