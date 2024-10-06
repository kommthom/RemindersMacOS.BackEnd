//
//  EmailBuilder.swift
//
//
//  Created by Thomas Benninghaus on 04.01.24.
//

import Lingo
import Vapor
import LeafKit
import Resources
import Foundation
import DTO

public class EmailBuilder: EmailBuilderProtocol {
    private var application: Application
    private var templateData: [String : String]
    //private var textConverter: TextConverter?
    private let localization: LocalizationProtocol
    private var language: LanguageIdentifier
    private var templateType: EmailTemplateType
    private var recipient: EmailAddress?
    
    required public init(application: Application) throws { //, textConverter: TextConverter? = nil) throws {
        self.application = application
        self.templateData = .init()
        self.localization = try application.localization.provide()
        self.language = .notSet
        self.templateType = .notSet
        self.recipient = nil
    }
    
    public func setRecipient(recipientEmailAddress: EmailAddress) -> EmailBuilder {
        recipient = recipientEmailAddress
        templateData["recipientName"] = recipientEmailAddress.name
        templateData["recipientEmail"] = recipientEmailAddress.address
        return self
    }
    
    private func verifyURL(for token: String) -> String {
        #"http://\#(application.config.frontendURL):\#(application.config.port)/api/auth/email-verification?token=\#(token)"#
    }
    
    public func setVerifyUrl(for token: String) -> EmailBuilder {
        templateData["verify_url"] = verifyURL(for: token)
        return self
    }
    
    private func resetPasswordURL(for token: String) -> String {
        #"http://\#(application.config.frontendURL):\#(application.config.port)/api/auth/reset-password?token=\#(token)"#
    }
    
    public func setResetPasswordUrl(for token: String) -> EmailBuilder {
        templateData["reset_url"] = resetPasswordURL(for: token)
        return self
    }
    
    public func setLanguage(language: LanguageIdentifier) -> EmailBuilder {
        self.language = language
        templateData["locale"] = language.code
        return self
    }
    
    public func setEmailTemplate(template: EmailTemplateType) -> EmailBuilder {
       self.templateType = template
       return self
    }
    
    private func loadTemplate(templateType: EmailTemplateType, language: LanguageIdentifier, templateData: [String: String]) throws -> Future<EmailPayload> {
        //let templateLoader: EmailTemplateLoader = .init(languageCode: language.code, localization: localization)
        //let subject = templateLoader.loadSubject(domain: templateType.domain)
        //let content = templateLoader.loadContent(templateName: templateType.templateName, templateData: templateData)
        self.application.logger.info( { "Start rendering \(application.directory.viewsDirectory)/\(templateType.templateName).leaf"}())
        let contentView: Future<View> = self.application.view.render("\(templateType.templateName).leaf", templateData)
        return contentView
            .map() { content in
                self.application.logger.info( { "\(String(buffer: content.data))" }())
                let subject = self.localization.localize("\(templateType.domain).subject", locale: language.code, interpolations: nil)
                return EmailPayload(to: self.recipient!, subject: subject, content: String(buffer: content.data), templateName: templateType.templateName)
            }
    }
    
    private func validateBeforeBuild() throws {
        guard let _ = recipient else {
            throw EmailError.recipientNotSpecified
        }
        guard language != .notSet else {
            throw EmailError.languageNotSpecified
        }
        switch templateType {
        case .resetPasswordEmail:
            guard !(templateData["reset_url"]?.isEmpty ?? true) else {
                throw EmailError.interpolationsNotComplete
            }
        case .verificationEmail:
            guard !(templateData["verify_url"]?.isEmpty ?? true) else {
                throw EmailError.interpolationsNotComplete
            }
        case .notSet:
            throw EmailError.templateTypeNotSpecified
        }
    }
    
    public func build() throws -> Future<EmailPayload> {
        try validateBeforeBuild()
        return try loadTemplate(templateType: templateType, language: language, templateData: templateData)
    }
}
