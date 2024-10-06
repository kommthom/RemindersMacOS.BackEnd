//
//  Database+CreateEnum.swift
//
//
//  Created by Thomas Benninghaus on 24.03.24.
//

import Foundation
import FluentKit

extension Database {
    public func createEnum(_ name: String, allCases: [String]) -> Future<DatabaseSchema.DataType> {
        var enumBuilder = self.enum(name)
        for enumCase in allCases {
            enumBuilder = enumBuilder.case(enumCase)
        }
        return enumBuilder.create()
    }
}
