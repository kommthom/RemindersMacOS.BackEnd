//
//  StringMonthParser.swift
//
//
//  Created by Thomas Benninghaus on 25.03.24.
//

import Foundation

public struct StringMonthParser: StringComponentParserProtocol {
    private let localizedMonthNames: [String]
    private let shortMonthNames: [String]
    
    public init(localizedMonthNames: [String], shortMonthNames: [String]) {
        self.localizedMonthNames = localizedMonthNames
        self.shortMonthNames = shortMonthNames
    }
    
    public func parse(input: ParsedComponent) -> ParsedComponent {
        if let month = localizedMonthNames.firstIndex(where: { $0 == input.stringValue } ) {
            return ParsedComponent(stringValue: input.stringValue, parsedValue: .month(month + 1))
        } else if let month = shortMonthNames.firstIndex(where: { $0 == input.stringValue } ) {
            return ParsedComponent(stringValue: input.stringValue, parsedValue: .month(month + 1))
        } else {
            return input
        }
    }
}
