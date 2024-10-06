//
//  StringArrayParserProtocol.swift
//  
//
//  Created by Thomas Benninghaus on 28.03.24.
//

import Foundation

public protocol StringArrayParserProtocol {
    var useParser: StringComponentParserProtocol { get }
    func parse(input: ParsedComponents) -> ParsedComponents
}
