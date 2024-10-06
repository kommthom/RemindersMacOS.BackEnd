//
//  UUIDRequest.swift
//
//
//  Created by Thomas Benninghaus on 27.12.23.
//

import Vapor

public struct UUIDRequest: Content {
    public let id: UUID
    
    public init(id: UUID) {
        self.id = id
    }
}
 
extension UUIDRequest {
    public init(from idRequest: IdRequest) {
        self.init(id: UUID(uuidString: idRequest.id) ?? UUID())
    }
}

// Used in CotrollerTests for the "testButton" method because it reads
/// the HTML for the form associated with the named button and creates a list of the
/// hidden inputs and their values. This protocol guarantees that the context passed to
/// "testButton" has the required initializer method, i.e., init(pairs:).
public protocol PairableContent: Content {
    init()
    init(pairs: [String: String])
}

/// Used to decode a received UUID.
public struct IdRequest: PairableContent {
    public var id: String = ""

    public init() {}

    /// Receive a UUID from a request.
    public init(id: String) {
        self.id = id
    }

    /// Create a context from a list of name:value pairs during testing.
    public init(pairs: [String: String]) {
        if let id = pairs["id"] { self.id = id }
    }
}
