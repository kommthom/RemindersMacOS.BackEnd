//
//  EmailTemplateLoader.swift
//  
//
//  Created by Thomas Benninghaus on 05.01.24.
//

import Vapor
import Lingo
import Foundation
import Resources

struct EmailTemplateLoader {
    let languageCode: LocaleIdentifier
    let localization: LocalizationProtocol
    private let logger = Logger(label: "reminders.backend")
    
    func loadSubject(domain: String) throws -> String {
        return localization.localize("\(domain).subject", locale: languageCode, interpolations: nil)
    }
    
    private func loadTemplateFile(templateName: String) -> String {
        do {
            return try String(contentsOf: ResourcePaths.htmlTemplatesPath.appendingPathComponent("\(templateName).html"))
        } catch let error {
            logger.error("Email template file could not be loaded:\n\(error.localizedDescription)")
            return ""
        }
    }
    
    func loadContent(templateName: String, templateData: [String : String]) -> String {
        let templateString: String = loadTemplateFile(templateName: templateName)
        let textTranslator: TextLocalizationProtocol = TextLocalization.init(inputString: templateString, localization: localization, textConverter: stringHtmlEscape)
        return textTranslator.localize(languageCode: languageCode, interpolations: templateData)
    }
}
