//
//  DueDateCalculatorArguments.swift
//
//
//  Created by Thomas Benninghaus on 05.04.24.
//

import Foundation

public struct DueDateCalculatorArguments {
    public var type: DateComponent
    public var json: String?
    public var dateComponentInterval: DateComponentInterval?
    public let everyExternal: Int?
    public var timePeriodsCheck: ((_ date: Date) -> Date)?
    
    public init(type: DateComponent = .year, json: String? = nil, dateComponentInterval: DateComponentInterval? = nil, everyExternal: Int? = nil, timePeriodsCheck: ((_ date: Date) -> Date)? = nil) {
        self.type = type
        self.json = json
        self.dateComponentInterval = dateComponentInterval
        self.everyExternal = everyExternal
        self.timePeriodsCheck = timePeriodsCheck
    }
    
    public init?(previousArgs: DueDateCalculatorArguments) {
        guard previousArgs.type != .quarterHour  else { return nil }
        self.init(type: previousArgs.type.nextCalculatorComponent(), json: previousArgs.json, everyExternal: previousArgs.everyExternal, timePeriodsCheck: previousArgs.timePeriodsCheck)
    }
}
