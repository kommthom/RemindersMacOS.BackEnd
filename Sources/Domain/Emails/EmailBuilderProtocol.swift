//
//  EmailBuilderProtocol.swift
//  
//
//  Created by Thomas Benninghaus on 09.01.24.
//

import Foundation
import Vapor
import DTO
import Resources

public protocol EmailBuilderProtocol {
    init(application: Application) throws //, textConverter: TextConverter?) throws
    func setRecipient(recipientEmailAddress: EmailAddress) -> EmailBuilder
    func setVerifyUrl(for token: String) -> EmailBuilder
    func setResetPasswordUrl(for token: String) -> EmailBuilder
    func setLanguage(language: LanguageIdentifier) -> EmailBuilder
    func setEmailTemplate(template: EmailTemplateType) -> EmailBuilder
    func build() throws -> Future<EmailPayload>
}
