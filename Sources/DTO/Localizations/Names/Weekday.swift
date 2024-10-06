//
//  Weekday.swift
//
//
//  Created by Thomas Benninghaus on 15.03.24.
//

import Foundation

public enum Weekday: String, CustomStringConvertible, CaseIterable {
    case sunday = "sunday"
    case monday = "monday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    case thursday = "thursday"
    case friday = "friday"
    case saturday = "saturday"

    public init?(_ weekday: Int) {
        self.init(rawValue: Weekday.allCases[weekday].rawValue)
    }

    ///  Initialize with specific date, gets current weekday using Calendar
    public init?(date: Date) {
        self.init(date.weekday)
    }
    
    public var index: Int {
        Weekday.allCases.firstIndex(where: { $0 == self } )!
    }
    
    public var description: String { return self.rawValue }

    /// Weekday for this moment, alias to call `Weekday(date: Date())`
    public static var current: Weekday {
        return Weekday(date: Date())!
    }

    /// Creates list of all weekdays in week, respects firstWeekday settings in `Calendar.current`
    public static var all: [Weekday] {
        return LocaleIdentifier.notSet.localeNames.startingFirstWeekdayNames.map {
            return Weekday(rawValue: $0)!
        }
    }
    
    /// same with weekdays as string
    public static var allEnum: [String] {
        return all.map {
            return String(describing: $0)
        }
    }
    
    public static func getLocalizedWeekday(locale: LocaleIdentifier = .notSet, find weekday: String) -> Weekday? {
        if let index = Weekday.getLocalizedWeekdayIndex(locale: locale, find: weekday.trimmingCharacters(in: [","])) {
            return Weekday(index)
        } else if let index = Weekday.getLocalizedWeekdayIndex(locale: locale, find: weekday, useShortNames: true) {
            return Weekday(index)
        } else { return nil }
    }
    
    public static func getLocalizedWeekdayIndex(locale: LocaleIdentifier = .notSet, find weekday: String, useShortNames: Bool = false) -> Int? {
        return useShortNames ? locale.localeNames.shortWeekdayNames.firstIndex(of: weekday) : locale.localeNames.allWeekdayNames.firstIndex(of: weekday)
    }

    /// Creates list of all standard working weekdays in week
    public static var workingDays: [Weekday] {
        return [.monday, .tuesday, .wednesday, .thursday, .friday]
    }

    /// Compare method that can be used in `Collection.sorted` method
    public static func compare(_ lhs: Weekday, _ rhs: Weekday) -> Bool {
        let lhsAligned = (lhs.index + Date.sharedCalendar.firstWeekday) % 7
        let rhsAligned = (rhs.index + Date.sharedCalendar.firstWeekday) % 7
        return lhsAligned < rhsAligned
    }
}
