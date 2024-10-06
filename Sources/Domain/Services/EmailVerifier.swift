//
//  EmailVerifier.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import Queues
import Resources

struct EmailVerifier {
    let emailTokenRepository: EmailTokenRepositoryProtocol
    let application: Application
    let queue: Queue
    let eventLoop: EventLoop
    let generator: RandomGenerator
    
    func verify(for user: UserModel) -> Future<Void> {
        do {
            let token = generator.generate(bits: 256)
            let emailToken = try EmailToken(userID: user.requireID(), token: SHA256.hash(token))
            let _ = emailTokenRepository
                .create(emailToken)
            return try EmailBuilder(application: self.application) //textConverter: stringHtmlEscape)
                            .setRecipient(recipientEmailAddress: EmailAddress(address: user.email, name: user.fullName))
                            .setVerifyUrl(for: token)
                            .setEmailTemplate(template: .verificationEmail)
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

/*extension Application {
    var emailVerifier: EmailVerifier {
        .init(emailTokenRepository: self.repositories.emailTokens, config: self.config, queue: self.queues.queue, eventLoop: eventLoopGroup.next(), generator: self.random, languageCode: "en")
    }
}*/

extension Request {
    var emailVerifier: EmailVerifier {
        .init(emailTokenRepository: self.emailTokens, application: application, queue: self.queue, eventLoop: eventLoop, generator: self.application.random)
    }
}
