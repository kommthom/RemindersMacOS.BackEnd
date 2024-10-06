//
//  UserSessionAuthenticator.swift
//
//
//  Created by Thomas Benninghaus on 09.03.24.
//

import Vapor
import Fluent
import Foundation

struct UserSessionAuthenticator: SessionAuthenticator {
    typealias User = AuthenticatedUser
    func authenticate(sessionID: UUID, for request: Request) -> Future<Void> {
        return UserModel.find(sessionID, on: request.db)
            .map { userModel in
                guard let _ = userModel else {
                    Logger(label: "reminders.backend.authenticate").info("Cannot find sessionId \(request.session.id?.string ?? "")")
                    return
                }
                request.auth.login(AuthenticatedUser(model: userModel!))
                Logger(label: "reminders.backend.authenticate").info("User: \(request.auth.get(AuthenticatedUser.self)?.email ?? "Not authenticated")")
            }
    }
}
