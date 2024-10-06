//
//  PasswordResetter.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import Queues
import Resources

struct PasswordResetter {
    let queue: Queue
    let repository: PasswordTokenRepositoryProtocol
    let eventLoop: EventLoop
    let application: Application
    let generator: RandomGenerator
    
    /// Sends a email to the user with a reset-password URL
    func reset(for user: UserModel) -> Future<Void> {
        do {
            let token = generator.generate(bits: 256)
            let resetPasswordToken = try PasswordToken(userID: user.requireID(), token: SHA256.hash(token))
            let _ = repository
                .create(resetPasswordToken)
            return try EmailBuilder(application: self.application) //, textConverter: stringHtmlEscape)
                            .setRecipient(recipientEmailAddress: EmailAddress(address: user.email, name: user.fullName))
                            .setResetPasswordUrl(for: token)
                            .setEmailTemplate(template: .resetPasswordEmail)
                            .setLanguage(language: user.locale.language)
                            .build()
                            .flatMap { payload in
                                return self.queue.dispatch(EmailJob.self, payload)
                            }
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
}

extension Request {
    var passwordResetter: PasswordResetter {
        .init(queue: self.queue, repository: self.passwordTokens, eventLoop: self.eventLoop, application: self.application, generator: self.application.random)
    }
}
