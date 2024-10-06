//
//  SignInContext.swift
//
//
//  Created by Thomas Benninghaus on 29.01.24.
//

import Vapor
import Fluent

struct SignInContext {
    let name: String
    let error: String?

    init(name: String, error: String? = nil) {
        self.name = name
        self.error = error
    }
}
