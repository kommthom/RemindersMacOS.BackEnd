//
//  CompositeStrings.swift
//  
//
//  Created by Thomas Benninghaus on 27.04.24.
//

import Foundation

public struct CompositeStrings {
    public let strings: [CompositeString]
    
    public init(compositeStrings: [CompositeString]) {
        self.strings = compositeStrings
    }
    
    public init(strings: [String]) {
        self.init(compositeStrings: strings.map { CompositeString(rawValue: $0)! } )
    }
    
    public func first(matching predicate: Predicate<CompositeString>) -> CompositeString? {
        strings.first(where: predicate.matches)
    }
}
