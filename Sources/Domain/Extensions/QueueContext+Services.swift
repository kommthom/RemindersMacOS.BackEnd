//
//  QueueContext+Services.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import Fluent
import Queues

extension QueueContext {
    var db: Database {
        application.databases
            .database(logger: self.logger, on: self.eventLoop)!
    }
    
    func smtp() -> SMTPProviderProtocol {
        application.smtp(eventLoop: self.eventLoop)
    }
    
    var appConfig: AppConfig {
        application.config
    }
}
