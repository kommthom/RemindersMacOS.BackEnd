//
//  StringToTimeParser.swift
//
//
//  Created by Thomas Benninghaus on 25.03.24.
//

import Foundation

public struct StringToTimeParser: StringComponentParserProtocol {
    private var timeParseStrategy:Date.ParseStrategy
    
    public init(timeParseStrategy: Date.ParseStrategy) {
        self.timeParseStrategy = timeParseStrategy
    }
    
    public func parse(input: ParsedComponent) -> ParsedComponent {
        guard let newTime = try? Date(input.stringValue, strategy: timeParseStrategy) else { return input }
        return ParsedComponent(stringValue: input.stringValue, parsedValue: .time(newTime))
    }
}
