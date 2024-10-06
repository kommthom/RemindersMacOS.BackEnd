//
//  RiggedRandomGenerator.swift
//
//
//  Created by Thomas Benninghaus on 29.12.23.
//

@testable import Domain
import Vapor

extension Application.RandomGenerators.Provider {
    static func rigged(value: String) -> Self {
        .init {
            $0.randomGenerators.use { _ in RiggedRandomGenerator(value: value) } }
    }
}

struct RiggedRandomGenerator: RandomGenerator {
    let value: String
    
    func generate(bits: Int) -> String {
        return value
    }
}
