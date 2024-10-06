//
//  SMTPProviderProtocol.swift
//  
//
//  Created by Thomas Benninghaus on 29.12.23.
//

import Vapor

public protocol SMTPProviderProtocol {
    func send(_ email: Email, logHandler: ((String) -> Void)?) -> EventLoopFuture<Result<Bool, Error>>
    func send(_ email: Email, logHandler: ((String) -> Void)?) async throws
    func delegating(to eventLoop: EventLoop) -> SMTPProviderProtocol
}
