//
//  DateComponent.swift
//  
//
//  Created by Thomas Benninghaus on 05.04.24.
//

import Foundation

public enum DateComponent: Int, CaseIterable, Codable, Strideable, CustomStringConvertible {
    case year = 0
    case quarter = 1
    case month = 2
    case week = 3
    case day = 4
    case hour = 5
    case quarterHour = 6
    
    public init?(rawValue: String) {
        self.init(rawValue: {
            return switch rawValue {
                case "year": 0
                case "quarter": 1
                case "month": 2
                case "week": 3
                case "day": 4
                case "hour": 5
                case "quarterHour": 6
                default: 4
                }
            }()
        )
    }
    
    public var description: String { String(describing: self) }
    
    public func distance(to other: DateComponent) -> Int {
        other.rawValue - self.rawValue
    }
    
    public func advanced(by n: Int = 1) -> DateComponent {
        DateComponent(rawValue: self.rawValue + n) ?? .quarterHour
    }
    
    public func nextCalculatorComponent() -> DateComponent {
        switch self {
            case .year, .hour: advanced(by: 2)
            default: advanced()
        }
    }
}
