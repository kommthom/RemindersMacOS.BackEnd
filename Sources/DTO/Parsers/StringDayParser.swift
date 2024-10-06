//
//  StringDayParser.swift
//  
//
//  Created by Thomas Benninghaus on 25.03.24.
//

import Foundation

public struct StringDayParser: StringComponentParserProtocol {
    public var locale: LocaleIdentifier
    public var timeZone: TimeZone
    
    public init(locale: LocaleIdentifier, timeZone: TimeZone = TimeZone(identifier: "UTC")!) {
        self.locale = locale
        self.timeZone = timeZone
    }
    
    public func parse(input: ParsedComponent) -> ParsedComponent {
        guard let newDate = try? Date(input.stringValue, strategy: locale.localeFormatting(timeZone: self.timeZone).dateParseStrategy(formatType: .dd)!) else { return input }
        return ParsedComponent(stringValue: input.stringValue, parsedValue: .day(newDate))
    }
}
