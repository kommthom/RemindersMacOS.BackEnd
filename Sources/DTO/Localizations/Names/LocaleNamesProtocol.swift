//
//  LocaleNamesProtocol.swift
//
//
//  Created by Thomas Benninghaus on 21.05.24.
//

import Foundation

public protocol LocaleNamesProtocol {
    var locale: LocaleIdentifier { get }
}

public extension LocaleNamesProtocol {
    func weekDay(_ date: Date) -> String {
        return date.formatted(.dateTime
            .weekday(.wide)
            .locale(locale.locale))
    }

    var allMonthNames: [String] {
        if locale == .notSet {
            return Month.allCases.map { $0.rawValue }
        } else {
            var calendar = Calendar.current
            calendar.locale = locale.locale
            return calendar.monthSymbols
        }
    }
    
    var shortMonthNames: [String]  {
        if locale == .notSet {
            return Month.allCases.map { $0.rawValue }
        } else {
			var calendar = Calendar.current
            calendar.locale = locale.locale
            return calendar.shortMonthSymbols
        }
    }
    
    var allWeekdayNames: [String] {
        if locale == .notSet {
            return Weekday.allCases.map { $0.rawValue }
        } else {
            var calendar = Calendar.current
            calendar.locale = locale.locale
            return calendar.weekdaySymbols
        }
    }
    
    var startingFirstWeekdayNames: [String] {
        let firstWeekday = Calendar.current.firstWeekday - 1
        let names = allWeekdayNames
        return firstWeekday == 0 ? names : Array(names[firstWeekday..<names.count]) + names[0..<firstWeekday]
    }
    
    var shortWeekdayNames: [String] {
        if locale == .notSet {
            return [0...7].map { "\($0)" }
        } else {
            var calendar = Calendar.current
            calendar.locale = locale.locale
            return calendar.shortWeekdaySymbols
        }
    }
}
