//
//  StringYearParser.swift
//  
//
//  Created by Thomas Benninghaus on 21.04.24.
//

import Foundation

public struct StringYearParser: StringComponentParserProtocol {
    public var locale: LocaleIdentifier
    
    public init(locale: LocaleIdentifier) {
        self.locale = locale
    }
    
    public func parse(input: ParsedComponent) -> ParsedComponent {
        if let newDate = try? Date(input.stringValue, strategy: locale.yyyyParseStrategy) {
            return ParsedComponent(stringValue: input.stringValue, parsedValue: .year(newDate.year))
        } else {
            return input
        }
    }
}
