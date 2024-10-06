//
//  UserCredentialsAuthenticator.swift
//  
//
//  Created by Thomas Benninghaus on 09.03.24.
//

import Vapor
import Fluent
import DTO

struct UserCredentialsAuthenticator: CredentialsAuthenticator {
    typealias Credentials = LoginRequest
    func authenticate(credentials: Credentials, for request: Request) -> Future<Void> {
        return UserModel
            .query(on: request.db)
            .filter(\.$email == credentials.email)
            .first()
            .map { userModel in
                guard let _ = userModel else {
                    Logger(label: "reminders.backend.authenticate").info("Cannot find Email \(credentials.email)")
                    return
                }
                do {
                    guard try Bcrypt.verify(credentials.password, created: userModel!.passwordHash) else {
                        Logger(label: "reminders.backend.authenticate").info("Incorrect password")
                        return
                    }
                    request.auth.login(AuthenticatedUser(model: userModel!))
                }
                catch {
                    // do nothing...
                }
            }
    }
}
