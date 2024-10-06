//
//  StringComponentParserProtocol.swift
//
//
//  Created by Thomas Benninghaus on 25.03.24.
//

import Foundation

public protocol StringComponentParserProtocol {
    func parse(input: ParsedComponent) -> ParsedComponent
}
