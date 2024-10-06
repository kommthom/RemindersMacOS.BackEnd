//
//  YearCalculator.swift
//  
//
//  Created by Thomas Benninghaus on 04.04.24.
//

import Foundation

public struct YearCalculator: DueDateCalculatorProtocol {
    private let yearInterval: DateComponentInterval?
    private let delegateCalculator: DueDateCalculatorProtocol?
    private let every: Int?
    
    public init?(args: DueDateCalculatorArguments) {
        if let json = args.json {
            let jsonData = json.data(using: .utf8)!
            guard let yearInterval = try! JSONDecoder().decode(DateComponentInterval?.self, from: jsonData) else { return nil }
            guard yearInterval.component == .year else { return nil }
            self.yearInterval = yearInterval
        } else if let yearInterval = args.dateComponentInterval {
            guard yearInterval.listType != DateComponentListType.none else { return nil }
            self.yearInterval = yearInterval
        } else { return nil }
        if let childType = yearInterval?.child!.component {
            self.delegateCalculator = DueDateCalculatorFactory.createWithLoop(firstArgs: DueDateCalculatorArguments(type: childType, dateComponentInterval: yearInterval?.child))
        } else { self.delegateCalculator = nil }
        self.every = nil
    }
    
    public func serialize() throws -> String {
        return String(data: try JSONEncoder().encode(yearInterval), encoding: .utf8)!
    }
    
    private func calculateDelegate(_ forDate: Date) -> Date { delegateCalculator?.calculate(forDate) ?? forDate }

    private func calculateNextYear(_ forDate: Date) -> Date {
        let repetitions: Int = yearInterval?.listType == .fixed ? 1 : [every, yearInterval?.every, 1].firstNonNil({ $0 })!
        var nextDate: Date? = forDate
        for _ in 1...repetitions {
            nextDate = yearInterval?.dateRelativeList?.calculateNextDay(nextDate!)
            guard let _ = nextDate else { return Date.distantFuture }
        }
        return nextDate!
    }
    
    public func calculate(_ forDate: Date) -> Date {
        var nextDate: Date = yearInterval?.listType == .fixed || yearInterval?.dateRelativeList?.dateIn(forDate) ?? false ? forDate : calculateNextYear(forDate)
        var nextTime = calculateDelegate(nextDate)
        while nextDate.year != nextTime.year { nextDate = calculateNextYear(nextDate); if nextDate == Date.distantFuture { return nextDate }; nextTime = calculateDelegate(nextDate)}
        return nextTime
    }
}
