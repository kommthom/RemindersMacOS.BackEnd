//
//  StringIntParser.swift
//  
//
//  Created by Thomas Benninghaus on 25.03.24.
//

import Foundation

public struct StringIntParser: StringComponentParserProtocol {
    public func parse(input: ParsedComponent) -> ParsedComponent {
        let newInt = input.stringValue.trimmingSuffix(while: { $0 == "." } )
        guard input.stringValue.count - 2 < newInt.count  else { return input }
        guard let intValue = Int(newInt) else { return input }
        return ParsedComponent(stringValue: input.stringValue, parsedValue: .int(intValue))
    }
}
