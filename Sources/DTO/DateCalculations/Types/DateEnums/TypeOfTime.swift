//
//  TypeOfTime.swift
//  
//
//  Created by Thomas Benninghaus on 22.01.24.
//

import Foundation

public enum TypeOfTime: String, Codable, CustomStringConvertible, CaseIterable, Sendable {
    case normalWorkingTime = "normalWorkingTime"
    case normalLeisureTime = "normalLeisureTime"
    case normalLeisureTimeWE = "normalLeisureTimeWE"
    case sleepingTimeWE = "sleepingTimeWE"
    case sleepingTime = "sleepingTime"
    case eventTime = "eventTime"
    case extraWorkingTime = "extraWorkingTime"
    case extraLeisureTime = "extraLeisureTime"
    case individual = "individual"
    case none = "none"
    
    public var description: String {
        self.rawValue
    }
    
    public var isNormalTimePeriod: Bool {
        switch self {
            case .normalWorkingTime, .normalLeisureTime, .normalLeisureTimeWE, .sleepingTimeWE, .sleepingTime, .eventTime: true
            default: false
        }
    }
    
    public var isExtraTimePeriod: Bool {
        switch self {
            case .extraWorkingTime, .extraLeisureTime: true
            default: false
        }
    }
}
