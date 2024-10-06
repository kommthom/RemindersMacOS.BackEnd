//
//  CompositeStringParserProtocol.swift
//
//
//  Created by Thomas Benninghaus on 25.03.24.
//

import Foundation

public protocol CompositeStringParserProtocol: StringComponentParserProtocol {
    var useParsers: [StringComponentParserProtocol] { get }
    static func unwrap(input: ParsedComponent) -> ParsedComponents
}
