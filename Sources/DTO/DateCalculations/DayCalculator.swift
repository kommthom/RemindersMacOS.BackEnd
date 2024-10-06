//
//  DayCalculator.swift
//
//
//  Created by Thomas Benninghaus on 06.04.24.
//

import Foundation

public struct DayCalculator: DueDateCalculatorProtocol {
    private let dayInterval: DateComponentInterval?
    private let delegateCalculator: DueDateCalculatorProtocol?
    private let every: Int?
    
    public init?(args: DueDateCalculatorArguments) {
        if let json = args.json {
            let jsonData = json.data(using: .utf8)!
            guard let dayInterval = try! JSONDecoder().decode(DateComponentInterval?.self, from: jsonData) else { return nil }
            guard dayInterval.component == .day else { return nil }
            self.dayInterval = dayInterval
        } else if let dayInterval = args.dateComponentInterval {
            guard dayInterval.listType != DateComponentListType.none else { return nil }
            self.dayInterval = dayInterval
        } else { return nil }
        if let childType = dayInterval?.child!.component {
            self.delegateCalculator = DueDateCalculatorFactory.createWithLoop(firstArgs: DueDateCalculatorArguments(type: childType, dateComponentInterval: dayInterval?.child))
        } else { self.delegateCalculator = nil }
        self.every = nil
    }
    
    private func calculateDelegate(_ forDate: Date) -> Date { delegateCalculator?.calculate(forDate) ?? forDate }
    
    private func calculateNextDay(_ forDate: Date) -> Date {
        let repetitions: Int = dayInterval?.listType == .fixed ? 1 : [every, dayInterval?.every, 1].firstNonNil({ $0 })!
        var nextDate: Date? = forDate
        for _ in 1...repetitions {
            nextDate = dayInterval?.dateRelativeList?.calculateNextDay(nextDate!)
            guard let _ = nextDate else { return Date.distantFuture }
        }
        return nextDate!
    }
    
    public func calculate(_ forDate: Date) -> Date {
        var nextDay: Date = forDate
        var nextTime = calculateDelegate(nextDay)
        while !Date.sameDate(nextDay, nextTime) { nextDay = calculateNextDay(nextDay); if nextDay == Date.distantFuture { return nextDay };nextTime = calculateDelegate(nextDay)}
        return nextTime
    }
}
