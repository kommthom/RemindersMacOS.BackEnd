//
//  ParsedComponents.swift
//
//
//  Created by Thomas Benninghaus on 28.03.24.
//

import Foundation

public class ParsedComponents {
    public var components: [ParsedComponent]
    public var ready: Bool { components.allSatisfy { $0.ready } }
    public var isInitial: Bool { components.count == 1 && !components[0].ready }
    
    public init(components: [ParsedComponent], locale: LocaleIdentifier = .notSet) {
        self.components =
        if components.count == 1 && !components[0].ready {
            components[0].stringValue
                .replacingOccurrences(of: DTOConstants.shared.listSeparator, with: DTOConstants.shared.argumentsSeparator + KeyWord.and.localizedDescription(locale: locale) + DTOConstants.shared.argumentsSeparator)
                .split(separator: DTOConstants.shared.argumentsSeparator)
                .compactMap { ParsedComponent(stringValue: String($0))}
        } else {
            components
        }
    }
    
    public convenience init(stringValues: [String]) {
        self.init(components: stringValues.map { ParsedComponent(stringValue: $0) } )
    }
    
    public convenience init(stringValue: String) {
        self.init(components: [ParsedComponent(stringValue: stringValue)])
    }
    
    public var rawRepetition: RepetitionFromParse? {
        ParsedComponentsAnalyzer(rawValue: self)?.buildRawRepetition()
    }
}
