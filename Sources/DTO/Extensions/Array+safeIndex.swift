//
//  Array+safeIndex.swift
//
//
//  Created by Thomas Benninghaus on 17.04.24.
//

import Foundation

extension Array {
    public subscript (safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }

    public mutating func append(_ newElement: Element?) {
        if let element = newElement {
            self.append(element)
        }
    }
    public mutating func append(contentsOf: [Element?]) {
        self.append(contentsOf: contentsOf.compactMap { $0 })
    }
}
