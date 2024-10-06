//
//  RepetitionArgument.swift
//
//
//  Created by Thomas Benninghaus on 21.03.24.
//
/*
import Foundation

public struct RepetitionArgument {
    public let stringBuilder: ArgumentStringBuilder
    
    /// Init from Date weekday
    init(_ arguments: String, maxNo: Int = 2, locale: LocaleIdentifier = .notSet) {
        self.stringBuilder = ArgumentStringBuilder( (locale: locale)
            .addStringSplitted(string: arguments, maxSplits: maxNo)
    }
    
    /// Init from weekday repetition
    init(repetitions: Int = 1, weekday: Weekday, atTime: Date?, locale: LocaleIdentifier = .notSet) {
        self.stringBuilder = ArgumentStringBuilder(locale: locale)
            .addInt(intValues: [repetitions], withDot: true)
            .addWeekday(weekdays: [weekday])
            .addTimeNotNil(time: atTime)
    }
    
    /// Init from day of month
    init(dayOfMonth: Int = 1, atTime: Date?, locale: LocaleIdentifier = .notSet) {
        let day = Date.today.startOfMonth.offset(.day, dayOfMonth - 1)
        self.stringBuilder = ArgumentStringBuilder(locale: locale)
            .addDay(days: [day])
            .addTimeNotNil(time: atTime)
    }
    
    /// Init from day of year
    init(dayOfYear: Date, atTime: Date?, locale: LocaleIdentifier = .notSet) {
        self.stringBuilder = ArgumentStringBuilder(locale: locale)
            .addDayMonth(dayMonths: [dayOfYear])
            .addTimeNotNil(time: atTime)
    }
    
    /// Init from nth day of year
    init(dayOfYear: Int, atTime: Date?, locale: LocaleIdentifier = .notSet) {
        self.stringBuilder = ArgumentStringBuilder(locale: locale)
            .addInt(intValues: [dayOfYear], withDot: true)
            .addTimeNotNil(time: atTime)
    }
    
    /// Init from starting time
    init(startingTime: Date, locale: LocaleIdentifier = .notSet) {
        self.stringBuilder = ArgumentStringBuilder(locale: locale)
            .addTimeNotNil(time: startingTime)
    }
    
    /// Set time value from arguments
    public func addArgumentTime(_ midnight: Date) -> Date {
        guard let timeArgument = arguments[1].customDate(.localTime) else { return midnight }
        var returnValue = midnight
        if timeArgument.hour > 0 { returnValue = returnValue.offset(.hour, timeArgument.hour) }
        if timeArgument.minute > 0 { returnValue = returnValue.offset(.minute, timeArgument.minute) }
        return returnValue
    }
    
    public var weekdayOfMonth: WeekdayInMonth {
        let argumentSplit = arguments[0].split(separator: DTOConstants.shared.dot)
        if argumentSplit.count == 1 {
            return WeekdayInMonth(week: 1, weekday: Weekday.findLocaleWeekday(find: argumentSplit[0].trimmingCharacters(in: [DTOConstants.shared.argumentsSeparator]).lowercased()))
        }
        return WeekdayInMonth(week: Int(argumentSplit[0]) ?? 1, weekday: Weekday.findLocaleWeekday(find: argumentSplit[1].lowercased()))
    }
    
    public var dayOfWeek: Int { return Weekday.findLocaleWeekday(find: arguments[0].lowercased()) }
    
    public var dayOfMonth: Int { return arguments[0].customDate(.isoDay)?.day ?? 1 }
    
    public var dayOfYear: [Int] {
        if let _ = arguments[0].firstIndex(of: ".") {
            return [Int(arguments[0].split(separator: ".")[0]) ?? 1]
        } else {
            if let date = arguments[0].customDate(.isoMonthDay) { return [date.month, date.day] } else { return [1] }
        }
    }
    
    public var asString: String { return arguments.joined(separator: DTOConstants.shared.argumentsSeparator)}
}
*/
