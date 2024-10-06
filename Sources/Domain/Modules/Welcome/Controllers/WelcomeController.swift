//
//  WelcomeController.swift
//
//
//  Created by Thomas Benninghaus on 20.01.24.
//

import Fluent
import Vapor
import SwiftHtml

struct WelcomeController: RouteCollection {
    private let logger = Logger(label: "reminders.backend.welcome")
    /// Sets up the routes for WelcomeController.
    func boot(routes: RoutesBuilder) throws {
       routes.get(use: index)
    }

    /// Display the welcome page.
    func index(req: Request) async throws -> Response {
        logger.info("Load Welcome (Session: \(req.session.id?.string ?? ""), \(req.auth.get(AuthenticatedUser.self)?.name ?? ""))")
        return req.templates.renderHtml(WelcomeTemplate())
    }
}
