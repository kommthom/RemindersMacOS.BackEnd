//
//  StringArrayParser.swift
//
//
//  Created by Thomas Benninghaus on 29.03.24.
//

import Foundation

public struct StringArrayParser: StringArrayParserProtocol {
    public var useParser: StringComponentParserProtocol
    
    public init(useParser: StringComponentParserProtocol) {
        self.useParser = useParser
    }
    
    public func parse(input: ParsedComponents) -> ParsedComponents {
        return ParsedComponents(components: input.components.enumerated().map { index, parsedComponent in
            parsedComponent.ready ? parsedComponent : useParser.parse(input: parsedComponent)
            } , locale: useParser.locale)
    }
}
