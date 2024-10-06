//
//  StringYearMonthDayParser.swift
//
//
//  Created by Thomas Benninghaus on 21.04.24.
//

import Foundation

public struct StringYearMonthDayParser: StringComponentParserProtocol {
    public var locale: LocaleIdentifier
    
    public init(locale: LocaleIdentifier) {
        self.locale = locale
    }
    
    public func parse(input: ParsedComponent) -> ParsedComponent {
        if let newDate = try? Date(input.stringValue, strategy: locale.ddMMyyyyParseStrategy) {
            return ParsedComponent(stringValue: input.stringValue, parsedValue: .yearMonthDay(newDate.year, newDate.month, newDate.day))
        } else {
            return input
        }
    }
}
