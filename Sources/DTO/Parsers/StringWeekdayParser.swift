//
//  StringWeekdayParser.swift
//
//
//  Created by Thomas Benninghaus on 29.03.24.
//

import Foundation

public struct StringWeekdayParser: StringComponentParserProtocol {
    private let localizedWeekdayNames: [String]
    private let shortWeekdayNames: [String]
    
    public init(localizedWeekdayNames: [String], shortWeekdayNames: [String]) {
        self.localizedWeekdayNames = localizedWeekdayNames
        self.shortWeekdayNames = shortWeekdayNames
    }
    
    public func parse(input: ParsedComponent) -> ParsedComponent {
        if let weekday = localizedWeekdayNames.firstIndex(where: { $0 == input.stringValue } ) {
            return ParsedComponent(stringValue: input.stringValue, parsedValue: .weekday(Weekday(weekday)!))
        } else if let weekday = shortWeekdayNames.firstIndex(where: { $0 == input.stringValue } ) {
            return ParsedComponent(stringValue: input.stringValue, parsedValue: .weekday(Weekday(weekday)!))
        } else {
            return input
        }
    }
}
