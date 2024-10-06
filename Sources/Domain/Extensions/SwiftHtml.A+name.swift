//
//  SwiftHtml.A+name.swift
//
//
//  Created by Thomas Benninghaus on 20.01.24.
//

import SwiftHtml

extension SwiftHtml.A {
    func name(_ value: String) -> Self {
        attribute("name", value)
    }
}
