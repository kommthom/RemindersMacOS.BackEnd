//
//  HashableWrapper.swift
//
//
//  Created by Thomas Benninghaus on 01.06.24.
//

import Foundation

public struct Hashed<T: Sendable >: Hashable, Sendable {

  public let value: T
  public let hash: Int

  public init(value: T, hash: Int) {
    self.value = value
    self.hash = hash
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(hash)
  }

  public static func == (lhs: Hashed<T>, rhs: Hashed<T>) -> Bool {
      lhs.hashValue == rhs.hashValue
  }
}
