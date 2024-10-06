//
//  DatabaseConfigurationFactory+Environment.swift
//
//
//  Created by Thomas Benninghaus on 21.12.23.
//

import Foundation
import Vapor
import NIOCore
import FluentSQLiteDriver

/// Class that create configuration for SQLite from environment
public extension DatabaseConfigurationFactory {
    init(
        database: String,
        databasePath: String,
        maxConnectionsPerEventLoop: Int = 1,
        connectionPoolTimeout: NIOCore.TimeAmount = .seconds(10)
    ){
        if !FileManager.default.fileExists(atPath: databasePath) {
            let _ = shell(URL(string: "/usr/bin/sqlite3")!, [databasePath])
        }
        self = DatabaseConfigurationFactory.sqlite(SQLiteConfiguration(storage: .file(path: databasePath)), maxConnectionsPerEventLoop: maxConnectionsPerEventLoop, connectionPoolTimeout: connectionPoolTimeout
        )
    }
    
    /// Standard global instance of this class.
    static var environmental: Self {
        guard
            let path = Environment.get("SQLITE_DATABASE_PATH"),
            let database = Environment.get("SQLITE_DATABASE_NAME")
        else {
            fatalError("""
            The environment variable for SQLite must be set to start the application.
            "SQLITE_DATABASE_PATH" and "SQLITE_DATABASE_NAME".
            """)
        }
        return Self(database: database, databasePath: URL(fileURLWithPath: path, isDirectory: true).appending(component: "\(database).sqlite").absoluteString)
    }
}

