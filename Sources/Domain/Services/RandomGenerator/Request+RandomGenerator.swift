//
//  Request+RandomGenerator.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor

extension Request {
    public var random: RandomGenerator {
        self.application.random
    }
}
