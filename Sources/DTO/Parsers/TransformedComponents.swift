//
//  TransformedComponents.swift
//
//
//  Created by Thomas Benninghaus on 25.04.24.
//

import Foundation

public struct TransformedComponents {
    public var transformedComponents: Set<TransformedComponent>

    public init(transformedComponents: Set<TransformedComponent>) {
        self.transformedComponents = transformedComponents
    }
    
    public func makeDateComponentInterval(transformedComponentType: RepetitionFromParse.CodingKeys = .repetitionJSON) -> DateComponentInterval? {
        var dateComponentInterval: DateComponentInterval? = nil
        let count = self
            .filtered(matching: .isOfType(transformedComponentType: transformedComponentType))
            .count
        return self
            .filtered(matching: .isOfType(transformedComponentType: transformedComponentType))
            .sorted(by: > )
            .enumerated()
            .compactMap { index, component in
                if index == count {
                    let lastComponent = component.child
                    lastComponent!.child = dateComponentInterval
                    return lastComponent
                } else {
                    component.child?.child = dateComponentInterval
                    dateComponentInterval = component.child
                    return nil
                }
            }
            .first
        }
}

public extension TransformedComponents {
    func filtered(matching predicate: Predicate<TransformedComponent>) -> [TransformedComponent] {
        transformedComponents.filter(predicate.matches)
    }
    
    func first(matching predicate: Predicate<TransformedComponent>) -> TransformedComponent? {
        transformedComponents.first(where: predicate.matches)
    }
}
