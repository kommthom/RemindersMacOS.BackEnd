//
//  StringYearMonthParser.swift
//
//
//  Created by Thomas Benninghaus on 21.04.24.
//

import Foundation

public struct StringYearMonthParser: StringComponentParserProtocol {
    public var locale: LocaleIdentifier
    
    public init(locale: LocaleIdentifier) {
        self.locale = locale
    }
    
    public func parse(input: ParsedComponent) -> ParsedComponent {
        if let newDate = try? Date(input.stringValue, strategy: locale.MMyyyyParseStrategy) {
            return ParsedComponent(stringValue: input.stringValue, parsedValue: .yearMonth(newDate.year, newDate.month))
        } else {
            return input
        }
    }
}
