//
//  WeekCalculator.swift
//
//
//  Created by Thomas Benninghaus on 04.04.24.
//

import Foundation

public struct WeekCalculator: DueDateCalculatorProtocol {
    private let weekInterval: DateComponentInterval?
    private let delegateCalculator: DueDateCalculatorProtocol?
    private let every: Int?
    
    public init?(args: DueDateCalculatorArguments) {
        if let json = args.json {
            let jsonData = json.data(using: .utf8)!
            guard let weekInterval = try! JSONDecoder().decode(DateComponentInterval?.self, from: jsonData) else { return nil }
            guard weekInterval.component == .week else { return nil }
            self.weekInterval = weekInterval
        } else if let weekInterval = args.dateComponentInterval {
            guard weekInterval.listType != DateComponentListType.none else { return nil }
            self.weekInterval = weekInterval
        } else { return nil }
        if let childType = weekInterval?.child!.component {
            self.delegateCalculator = DueDateCalculatorFactory.createWithLoop(firstArgs: DueDateCalculatorArguments(type: childType, dateComponentInterval: weekInterval?.child))
        } else { self.delegateCalculator = nil }
        self.every = nil
    }
    
    public func serialize() throws -> String {
        return String(data: try JSONEncoder().encode(weekInterval), encoding: .utf8)!
    }
    
    private func calculateDelegate(_ forDate: Date) -> Date { delegateCalculator?.calculate(forDate) ?? forDate }
    /*private func calculateNextWeek(_ forDate: Date) -> Date {
        return switch weekInterval?.listType {
            case .fixed: weekInterval?.dateRelativeList?.calculateNextDay(forDate) ?? Date.distantFuture
            default: forDate.offset(.day, [every, weekInterval?.every, 1].firstNonNil({ $0 })!)
        }
    }
    public func calculate(_ forDate: Date) -> Date {
        var nextDay: Date = calculateNextWeek(forDate.yesterday).setTime(time: forDate, inTimeZone: false)
        var nextTime = calculateDelegate(nextDay)
        while !Date.sameDate(nextDay, nextTime) { nextDay = calculateNextWeek(nextDay); nextTime = calculateDelegate(nextDay)}
        return nextTime
    }
    */
    private func calculateNextWeek(_ forDate: Date) -> Date {
        let repetitions: Int = weekInterval?.listType == .fixed ? 1 : [every, weekInterval?.every, 1].firstNonNil({ $0 })!
        var nextDate: Date? = forDate
        for _ in 1...repetitions {
            nextDate = weekInterval?.dateRelativeList?.calculateNextDay(nextDate!)
            guard let _ = nextDate else { return Date.distantFuture }
        }
        return nextDate!
    }
    
    public func calculate(_ forDate: Date) -> Date {
        var nextDate: Date = weekInterval?.listType == .fixed || weekInterval?.dateRelativeList?.dateIn(forDate) ?? false ? forDate : calculateNextWeek(forDate)
        var nextTime = calculateDelegate(nextDate)
        while !Date.sameDate(nextDate.startOfWeek, nextTime.startOfWeek) { nextDate = calculateNextWeek(nextDate); if nextDate == Date.distantFuture { return nextDate }; nextTime = calculateDelegate(nextDate)}
        return nextTime
    }
}
