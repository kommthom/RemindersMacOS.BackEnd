//
//  TimeCalculator.swift
//  
//
//  Created by Thomas Benninghaus on 04.04.24.
//

import Foundation

public struct TimeCalculator: DueDateCalculatorProtocol {
    private let timeInterval: DateComponentInterval?
    private var timePeriodsCheck: ((_ date: Date) -> Date)
    private let every: Int?
    
    public init?(args: DueDateCalculatorArguments) {
        if let json = args.json {
            guard let timeInterval = DateComponentInterval(rawValue: json) else { return nil }
            self.timeInterval = timeInterval
        } else if let timeInterval = args.dateComponentInterval {
            self.timeInterval = timeInterval
        } else { return nil }
        self.timePeriodsCheck = args.timePeriodsCheck ?? { $0 }
        self.every = args.everyExternal
    }
    
    public func calculate(_ forDate: Date) -> Date {
        let newDate: Date = switch timeInterval?.listType {
            case nil, .none?: forDate.nextQuarterHour
            case .all: forDate.isPast ? Date.tomorrow.dateInTimeZone : forDate
            case .fixed: self.timeInterval?.dateRelativeList == nil ? forDate : self.timeInterval?.dateRelativeList?.items.compactMap { forDate.setTime(time: $0.time) }.min() ?? forDate
            case .every:
            switch timeInterval?.component {
                case .quarterHour: forDate.offset(.minute, 15 * [every, timeInterval?.every, 1].firstNonNil({ $0 })! )
                case .hour: forDate.offset(.hour, [every, timeInterval?.every, 1].firstNonNil({ $0 })! )
                default: forDate.nextQuarterHour
            }
        }
        return timePeriodsCheck(newDate)
    }
}
