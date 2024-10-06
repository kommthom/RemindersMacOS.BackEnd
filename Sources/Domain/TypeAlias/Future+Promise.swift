//
//  Future+Promise.swift
//
//
//  Created by Thomas Benninghaus on 21.12.23.
//

import NIO

/// Convenience shorthand for `Future`.
///
/// Vapor also has this definition. The definition in Domain is to reduce the dependency on the framework by one step.
public typealias Future = EventLoopFuture

/// Convenience shorthand for `EventLoopPromise`.
///
/// Vapor also has this definition. The definition in Domain is to reduce the dependency on the framework by one step.
public typealias Promise = EventLoopPromise
