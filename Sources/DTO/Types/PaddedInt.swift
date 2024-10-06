//
//  PaddedInt.swift
//
//
//  Created by Thomas Benninghaus on 30.05.24.
//

import Foundation

public protocol PaddedInt: Codable, Hashable, Equatable, Sendable {
    var intValue: Int { get set }
    var digits: Int { get set }
    var presentation: String { get }
    
    init?(padded: String)
    init(intValue: Int, digits: Int)
}

extension PaddedInt {
    public var presentation: String { String(format: "%0\(self.digits)d", self.intValue) }
    public init?(padded: String) {
        self.digits = padded.count
        guard let intParsed = try? Int(padded, strategy: IntegerParseStrategy(format: IntegerFormatStyle<Int>())) else { return nil }
        self.intValue = intParsed
    }
    public init(intValue: Int, digits: Int) {
        self.intValue = intValue
        self.digits = digits
    }
}

public struct DefaultPaddedInt: PaddedInt {
    public var intValue: Int
    public var digits: Int
    
    public init(intValue: Int, digits: Int) {
        self.intValue = intValue
    }
}
