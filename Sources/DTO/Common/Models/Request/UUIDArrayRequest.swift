//
//  UUIDArrayRequest.swift
//
//
//  Created by Thomas Benninghaus on 14.02.24.
//

import Vapor

public struct UUIDArrayRequest: Content {
    public let ids: [UUID]
    
    public init(ids: [UUID]) {
        self.ids = ids
    }
}
