//
//  AppConfig.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor

struct AppConfig {
    let frontendURL: String
    let port: String
    let noReplyEmail: String
    
    static var environment: AppConfig {
        guard
            let frontendURL = Environment.get("SITE_FRONTEND_URL"),
            let noReplyEmail = Environment.get("NO_REPLY_EMAIL"),
            let port = Environment.get("SITE_FRONTEND_PORT")
        else {
            fatalError("Please add app configuration to environment variables")
        }
        return .init(frontendURL: frontendURL, port: port, noReplyEmail: noReplyEmail) 
    }
}

extension Application {
    struct AppConfigKey: StorageKey {
        typealias Value = AppConfig
    }
    
    var config: AppConfig {
        get {
            storage[AppConfigKey.self] ?? .environment
        }
        set {
            storage[AppConfigKey.self] = newValue
        }
    }
}
