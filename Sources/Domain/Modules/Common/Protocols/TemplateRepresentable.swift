//
//  TemplateRepresentable.swift
//
//
//  Created by Thomas Benninghaus on 20.01.24.
//

import Vapor
import SwiftSgml

public protocol TemplateRepresentable {
    @TagBuilder
    func render(_ req: Request) throws -> Tag
}
