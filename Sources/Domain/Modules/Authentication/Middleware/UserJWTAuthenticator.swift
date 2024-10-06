//
//  UserJWTAuthenticator.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import JWT
import DTO

public struct UserJWTAuthenticator: JWTAuthenticator {    
    public func authenticate(jwt: Payload, for request: Request) -> Future<Void> {
        request.auth.login(jwt)
        return request.eventLoop.makeSucceededFuture(())
    }
    
    public init() { }
}
