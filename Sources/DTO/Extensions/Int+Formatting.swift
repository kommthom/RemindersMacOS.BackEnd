//
//  Int+Formatting.swift
//
//
//  Created by Thomas Benninghaus on 19.04.24.
//

import Foundation

extension Int {
    public func formatted(digits: Int = 1) -> String {
        String(format: "%0\(digits)d", self)
    }
}
