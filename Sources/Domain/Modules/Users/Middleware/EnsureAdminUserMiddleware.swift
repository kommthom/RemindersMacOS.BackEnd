//
//  EnsureAdminUserMiddleware.swift
//
//
//  Created by Thomas Benninghaus on 08.03.24.
//

import Vapor

// Middleware to protect the UserController routes, but it can be applied to any routes
struct EnsureAdminUserMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        if request.isAdministrator() {
            return try await next.respond(to: request)
        } else {
            throw Abort(.unauthorized)
        }
    }
}

