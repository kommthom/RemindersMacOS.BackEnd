//
//  StringDateParser.swift
//  
//
//  Created by Thomas Benninghaus on 27.05.24.
//

import Foundation

public struct StringDateParser: StringComponentParserProtocol {
    private let dateParseStrategy: Date.ParseStrategy
    
    public init(dateParseStrategy: Date.ParseStrategy) {
        self.dateParseStrategy = dateParseStrategy
    }
    
    public func parse(input: ParsedComponent) -> ParsedComponent {
        if let newDate = try? Date(input.stringValue, strategy: dateParseStrategy) {
            return ParsedComponent(stringValue: input.stringValue, parsedValue: .date(newDate))
        } else {
            return input
        }
    }
}
