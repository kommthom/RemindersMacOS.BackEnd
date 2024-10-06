//
//  MonthCalculator.swift
//  
//
//  Created by Thomas Benninghaus on 04.04.24.
//

import Foundation

public struct MonthCalculator: DueDateCalculatorProtocol {
    private let monthInterval: DateComponentInterval?
    private let delegateCalculator: DueDateCalculatorProtocol?
    private let every: Int?
    
    public init?(args: DueDateCalculatorArguments) {
        if let json = args.json {
            let jsonData = json.data(using: .utf8)!
            guard let monthInterval = try! JSONDecoder().decode(DateComponentInterval?.self, from: jsonData) else { return nil }
            guard monthInterval.component == .month else { return nil }
            self.monthInterval = monthInterval
        } else if let monthInterval = args.dateComponentInterval {
            guard monthInterval.listType != DateComponentListType.none else { return nil }
            self.monthInterval = monthInterval
        } else { return nil }
        if let childType = monthInterval?.child!.component {
            self.delegateCalculator = DueDateCalculatorFactory.createWithLoop(firstArgs: DueDateCalculatorArguments(type: childType, dateComponentInterval: monthInterval?.child))
        } else { self.delegateCalculator = nil }
        self.every = nil
    }
    
    private func calculateDelegate(_ forDate: Date) -> Date { delegateCalculator?.calculate(forDate) ?? forDate }

    private func calculateNextMonth(_ forDate: Date) -> Date {
        let repetitions: Int = monthInterval?.listType == .fixed ? 1 : [every, monthInterval?.every, 1].firstNonNil({ $0 })!
        var nextDate: Date? = forDate
        for _ in 1...repetitions {
            nextDate = monthInterval?.dateRelativeList?.calculateNextDay(nextDate!)
            guard let _ = nextDate else { return Date.distantFuture }
        }
        return nextDate!
    }
    
    public func calculate(_ forDate: Date) -> Date {
        var nextDate: Date = monthInterval?.listType == .fixed || monthInterval?.dateRelativeList?.dateIn(forDate) ?? false ? forDate : calculateNextMonth(forDate)
        var nextTime = calculateDelegate(nextDate)
        while nextDate.month != nextTime.month { nextDate = calculateNextMonth(nextDate); if nextDate == Date.distantFuture { return nextDate }; nextTime = calculateDelegate(nextDate)}
        return nextTime
    }
}
