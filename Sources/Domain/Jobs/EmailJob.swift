//
//  EmailJob.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import Queues

public struct EmailPayload: Codable {
    public let templateName: String
    public let recipient: EmailAddress
    public let subject: String
    public let content: String
    
    public init(to recipient: EmailAddress, subject: String, content: String, templateName: String) {
        self.recipient = recipient
        self.subject = subject
        self.content = content
        self.templateName = templateName
    }
}

public struct EmailJob: Job {
    private let logger = Logger(label: "reminders.backend")
    public init() { }
    public func dequeue(_ context: QueueContext, _ payload: EmailPayload) -> Future<Void> {
        logger.info("Create email from \(context.appConfig.noReplyEmail) to \(payload.recipient.address) subject \(payload.subject)")
        let email = try? Email(
            from: EmailAddress(address: context.appConfig.noReplyEmail),
            to: [payload.recipient],
            subject: payload.subject,
            body: payload.content
        )
        logger.info("Send email to \(payload.recipient)")
        return context
            .smtp()
            .send(email!) { message in
                logger.info("\(message)")
            }
            .transform(to: ())
    }
}
