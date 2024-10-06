//
//  Request+Template.swift
//
//
//  Created by Thomas Benninghaus on 29.01.24.
//

import Vapor

public extension Request {
    var templates: TemplateRenderer { .init(self) }
}
