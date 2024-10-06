//
//  TimePeriodChecker.swift
//  
//
//  Created by Thomas Benninghaus on 22.03.24.
//

import Foundation

public struct TimeFromTo {
    let from: Date
    let to: Date
    
    public init(from: Date, to: Date) {
        self.from = from
        self.to = to
    }
}

public struct TimePeriodChecker {
    var timeIntervals: [TimeFromTo]

    public init(timePeriods: TimePeriodsDTO?, for days: [Date]? = nil, workingDayFilter: Bool = false, weekendFilter: Bool = false) {
        var dates: [Date] = days ?? .init()
        if dates.count == 0 {
            if workingDayFilter {
                let firstDate = Date.yesterday.nextWorkingDay.dateInTimeZone
                dates = [firstDate, firstDate.nextWorkingDay.dateInTimeZone]
            } else if weekendFilter {
                let firstDate = Date.yesterday.nextWeekendDay.dateInTimeZone
                dates = [firstDate, firstDate.nextWeekendDay.dateInTimeZone]
            } else {
                dates = [Date.today.dateInTimeZone, Date.tomorrow.dateInTimeZone]
            }
        }
        if timePeriods?.timePeriods.count ?? 0 > 0 {
            var timeIntervals: [TimeFromTo] = .init()
            var current: Int = -1
            for date in dates {
                for timePeriod in timePeriods!.filtered(matching: .isNormalPeriod(comparedTo: date)).sorted(by: { $0.compareFrom(with: $1, default: date) } ) { // ( { $0.day ?? date == date && $0.typeOfTime.isNormalTimePeriod } ).sorted(by: { $0.fromTime! > $1.fromTime!}) {
                    var from = date.offset(.minute, (timePeriod.fromTime!.hour * 60) + timePeriod.fromTime!.minute)
                    var to = date.offset(.minute, (timePeriod.toTime!.hour * 60) + timePeriod.toTime!.minute)
                    for extraPeriod in timePeriods!.filtered(matching: .isChildPeriod(parentId: timePeriod.id!, comparedTo: date)).sorted(by: { $0.compareFrom(with: $1, default: date)}) { // { $0.id == timePeriod.parentId && $0.day ?? date == date } ).sorted(by: { $0.fromTime ?? date > $1.fromTime ?? date } ) {
                        if let fromTime = extraPeriod.fromTime { from = fromTime }
                        if let toTime = extraPeriod.toTime { to = toTime }
                    }
                    if current > -1 {
                        if timeIntervals[current].to == from {
                            timeIntervals[current] = TimeFromTo(from: timeIntervals[current].from, to: to)
                        } else {
                            timeIntervals.append(TimeFromTo(from: from, to: to))
                            current += 1
                        }
                    } else {
                        timeIntervals.append(TimeFromTo(from: from, to: to))
                        current += 1
                    }
                }
            }
            self.timeIntervals = timeIntervals
        } else {
            self.timeIntervals = [TimeFromTo(from: dates[0], to: dates[1].tomorrow)]
        }
    }
    
    public func checkPeriods(date: Date) -> Date {
        for timeInterval in timeIntervals {
            if date < timeInterval.from { return timeInterval.from }
            if date <= timeInterval.to { return date }
        }
        return date
    }
}
