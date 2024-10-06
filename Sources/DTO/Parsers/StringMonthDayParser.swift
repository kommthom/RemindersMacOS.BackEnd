//
//  StringMonthDayParser.swift
//  
//
//  Created by Thomas Benninghaus on 25.03.24.
//

import Foundation

public struct StringMonthDayParser: StringComponentParserProtocol {
    public var locale: LocaleIdentifier
    
    public init(locale: LocaleIdentifier) {
        self.locale = locale
    }
    
    public func parse(input: ParsedComponent) -> ParsedComponent {
        guard let newDate = try? Date(input.stringValue, strategy: locale.ddMMParseStrategy) else { return input }
        return ParsedComponent(stringValue: input.stringValue, parsedValue: .monthDay(newDate.month, newDate.day))
    }
}
