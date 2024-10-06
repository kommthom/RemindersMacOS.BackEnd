//
//  ParsedComponent.swift
//  
//
//  Created by Thomas Benninghaus on 25.03.24.
//

import Foundation

public class ParsedComponent {
    public var stringValue: String
    public var parsedValue: ParsableComponentValue?
    public var ready: Bool { parsedValue != nil }
    
    public init(stringValue: String, parsedValue: ParsableComponentValue? = nil) {
        self.stringValue = stringValue
        self.parsedValue = parsedValue
    }
}
