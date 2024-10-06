//
//  RuleType.swift
//
//
//  Created by Thomas Benninghaus on 23.01.24.
//

import Foundation

public enum RuleType: String, Codable, CustomStringConvertible, CaseIterable {
    case onDue = "On_Due"
    case onStart = "On_Start"
    case onEnd = "On_End"
    case onBreak = "On_Break"
    case none = "none"
    
    public var description: String {
        self.rawValue
    }
}
