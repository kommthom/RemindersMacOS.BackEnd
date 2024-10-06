//
//  MockSmtpClient.swift
//  
//
//  Created by Thomas Benninghaus on 29.12.23.
//

import XCTVapor
import Foundation
@testable import Domain

struct MockSmtpClient: SMTPProviderProtocol {
    var eventLoop: EventLoop
    
    func send(_ email: Email, logHandler: ((String) -> Void)?) -> EventLoopFuture<Result<Bool, Error>> {
        fatalError()
    }
    func send(_ email: Email, logHandler: ((String) -> Void)?) async throws {
        fatalError()
    }
    
    func delegating(to eventLoop: EventLoop) -> SMTPProviderProtocol {
        var copy = self
        copy.eventLoop = eventLoop
        return copy
    }
}

extension Application.Smtp.Provider {
    static var fake: Self {
        .init {
            $0.smtp.use { app in
                MockSmtpClient(eventLoop: app.eventLoopGroup.next())
            }
        }
    }
}

