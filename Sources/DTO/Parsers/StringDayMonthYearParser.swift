//
//  StringDayMonthYearParser.swift
//
//
//  Created by Thomas Benninghaus on 22.04.24.
//

import Foundation
public struct StringDayMonthYearParser: StringComponentParserProtocol {
    public var locale: LocaleIdentifier
    
    public init(locale: LocaleIdentifier) {
        self.locale = locale
    }
    
    public func parse(input: ParsedComponent) -> ParsedComponent {
        if let parsedValue = parse(input: input.stringValue) {
            return ParsedComponent(stringValue: input.stringValue, parsedValue: .dateRelative(parsedValue))
        } else {
            return input
        }
    }
    
    public func parse(input: String) -> DateRelative? {
        var year: Int? = nil, month: Int? = nil, week: TypedWeek? = nil, day: Int? = nil, dayType: TypeOfDayNo? = nil
        var hour: Int? = nil, quarterHour: Int? = nil
        let dayTime = input.split(separator: DTOConstants.shared.argumentsSeparator, maxSplits: 1)
        for dayTimeIndex in 0...dayTime.count - 1 {
            let subString = String(dayTime[dayTimeIndex])
            if subString.contains(DTOConstants.shared.timeSeparator) {
                //if let newTime = try? Date(subString, strategy: locale.localeFormatting(timeZone: <#T##TimeZone#>).timeParseStrategy) { hour = newTime.hour; quarterHour = newTime.quarterHour }
            } else {
                let splitted = subString.components(separatedBy: locale.dateSeparator)
                switch splitted.count {
                    case 3:
                        let _ = self.locale.standardDateSequence.enumerated().map { index, type in
                            switch type {
                            case .day:
                                day = Int(splitted[index])
                                switch splitted[index].count {
                                    case 3: dayType = .ofYear
                                    case 2: dayType = .ofMonth
                                    case 1: dayType = .ofWeek
                                    default: dayType = nil; day = nil
                                }
                            case .year:
                                year = Int(splitted[index])
                            case .month:
                                month = Int(splitted[index])
                            default: let _ = 0
                            }
                        }
                    case 4:
                        let _ = self.locale.dateSequence.enumerated().map { index, type in
                            switch type {
                            case .day:
                                day = Int(splitted[index])
                                switch splitted[index].count {
                                    case 3: dayType = .ofYear
                                    case 2: dayType = .ofMonth
                                    case 1: dayType = .ofWeek
                                    default: dayType = nil; day = nil
                                }
                            case .year:
                                year = Int(splitted[index])
                            case .month:
                                month = Int(splitted[index])
                            case .week:
                                switch splitted[index].count {
                                    case 2: week = TypedWeek(type: .ofYear, week: Int(splitted[index])!)
                                    case 1: week = TypedWeek(type: .ofMonth, week: Int(splitted[index])!)
                                    default: week = nil
                                }
                            default: let _ = 0
                            }
                        }
                    default: let _ = 0
                }
            }
        }
        return year == nil && month == nil && week == nil && day == nil && dayType == nil && hour == nil && quarterHour == nil ? nil :
            DateRelative(year: year, month: month, week: week, day: day, dayType: dayType, hour: hour, quarterHour: quarterHour, locale: locale)
    }
}
