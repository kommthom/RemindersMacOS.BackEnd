//
//  ArgumentStringBuilder.swift
//
//
//  Created by Thomas Benninghaus on 31.03.24.
//
/*
import Foundation

public class ArgumentStringBuilder {
    private var arguments: [String]
    private var localization: (String) -> String
    private var locale: LocaleIdentifier
    
    public init(arguments: [String] = .init(), localization: @escaping (String) -> String = ({ $0 })) {
        self.arguments = arguments
        self.localization = localization
        let localeString = localization("locale")
        self.locale = localeString == "locale" ? .notSet : LocaleIdentifier(rawValue: localeString) ?? .notSet
    }
    
    public func build() -> String { arguments.joined(separator: DTOConstants.shared.argumentsSeparator)}
    
    private func addJoined(_ joinStrings: [String]) {
        let count = joinStrings.count - 1
        guard count >= 0 else { return }
        var joined = joinStrings[0]
        for index in 1...count - 1 {
            joined = DTOConstants.shared.listSeparator + joinStrings[index]
        }
        if count > 0 { joined = DTOConstants.shared.argumentsSeparator + KeyWord.and.localizedDescription(localization: localization) + DTOConstants.shared.argumentsSeparator + joinStrings[count] }
        arguments.append(joined)
    }
    
    /// Convert to string
    private func intAsString(intValue: Int, withDot: Bool) -> String { intValue.formatted(.number.grouping(.never).sign(strategy: .automatic)) + (withDot ? DTOConstants.shared.dot : "") }
    private func keywordString(keyword: KeyWord) -> String { keyword.localizedDescription(localization: localization) }
    private func weekdayString(weekday: Weekday) -> String { weekday.localizedDescription(locale: locale) }
    private func ddString(ddValue: Date) -> String { ddValue.formatted(.customDateTime.locale(locale).day(.twoDigits)) }
    private func mMString(mMValue: Date) -> String { mMValue.formatted(.customDateTime.locale(locale).month(.twoDigits)) }
    private func yyyyString(yyyyValue: Date) -> String { yyyyValue.formatted(.customDateTime.locale(locale).year(.padded(4))) }
    private func ddMMString(ddMMValue: Date) -> String { ddMMValue.formatted(.customDateTime.locale(locale).day(.twoDigits).month(.twoDigits)) }
    private func mMyyyyString(mMyyyyValue: Date) -> String { mMyyyyValue.formatted(.customDateTime.locale(locale).month(.twoDigits).year(.padded(4))) }
    private func ddMMyyyyString(ddMMyyyyValue: Date) -> String { ddMMyyyyValue.formatted(.customDateTime.locale(locale).day(.twoDigits).month(.twoDigits).year(.padded(4))) }
    private func hhmmString(hhmmValue: Date) -> String { hhmmValue.formatted(.customDateTime.locale(locale).hour(.twoDigits(amPM: .abbreviated)).minute(.twoDigits)) }
    
    /// Add to arguments
    public func addInt(intValues: [Int], withDot: Bool = false) -> ArgumentStringBuilder { addJoined(intValues.map { intAsString(intValue: $0, withDot: withDot) } ); return self }
    public func addKeyword(keywords: [KeyWord]) -> ArgumentStringBuilder { addJoined(keywords.map { keywordString(keyword: $0) } ); return self }
    public func addWeekday(weekdays: [Weekday]) -> ArgumentStringBuilder { addJoined(weekdays.map { weekdayString(weekday: $0) } ); return self }
    public func addDay(days: [Date]) -> ArgumentStringBuilder { addJoined(days.map { ddString(ddValue: $0) } ); return self }
    public func addMonth(months: [Date]) -> ArgumentStringBuilder { addJoined(months.map { mMString(mMValue: $0) } ); return self }
    public func addYear(years: [Date]) -> ArgumentStringBuilder { addJoined(years.map { yyyyString(yyyyValue: $0) } ); return self }
    public func addDayMonth(dayMonths: [Date]) -> ArgumentStringBuilder { addJoined(dayMonths.map { ddMMString(ddMMValue: $0) } ); return self }
    public func addMonthYear(monthYears: [Date]) -> ArgumentStringBuilder { addJoined(monthYears.map { mMyyyyString(mMyyyyValue: $0) } ); return self }
    public func addDayMonthYear(days: [Date]) -> ArgumentStringBuilder { addJoined(days.map { ddString(ddValue: $0) } ); return self }
    public func addTypedDate(dates: [Date], dateFormatType: CustomDateFormatType) -> ArgumentStringBuilder {
        return switch dateFormatType {
            case .dd: addDay(days: dates)
            case .mm: addMonth(months: dates)
            case .yyyy: addYear(years: dates)
            case .ddmm: addDayMonth(dayMonths: dates)
            case .mmyyyy: addMonthYear(monthYears: dates)
            case .ddmmyyyy: addDayMonthYear(days: dates)
            default: self
        }
    }
    public func addTime(times: [Date]) -> ArgumentStringBuilder { addJoined(times.map { hhmmString(hhmmValue: $0) } ); return self }
    public func addTimeNotNil(time: Date?) -> ArgumentStringBuilder { if let timeNotNil = time { arguments.append(hhmmString(hhmmValue: timeNotNil)) }; return self }
    public func addStringSplitted(string: String, maxSplits: Int) -> ArgumentStringBuilder {
        guard !string.isEmpty else { return self }
        var subStrings = string.split(separator: DTOConstants.shared.argumentsSeparator, maxSplits: maxSplits - 1).map { String($0) }
        for _ in (subStrings.count + 1)...maxSplits { subStrings.append("")}
        self.arguments.append(contentsOf: subStrings)
        return self
    }
}
*/
