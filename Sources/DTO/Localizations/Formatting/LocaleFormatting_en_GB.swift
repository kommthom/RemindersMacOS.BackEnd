//
//  LocaleFormatting_en_GB.swift
//  
//
//  Created by Thomas Benninghaus on 21.05.24.
//

import Foundation

public struct LocaleFormatting_en_GB: LocaleFormattingProtocol {
    public let locale: Locale
    public let timeZone: TimeZone
    
    public init(locale: Locale, timeZone: TimeZone) {
        self.locale = locale
        self.timeZone = timeZone
    }
    
    public func dateParseStrategy(formatType: CustomDateFormatType) -> Date.ParseStrategy? {
        return switch formatType {
            case .dd:
                Date.ParseStrategy(format: "\(day: .twoDigits)//", locale: locale, timeZone: timeZone)
            case .mm:
                Date.ParseStrategy(format: "/\(month: .twoDigits)/", locale: locale, timeZone: timeZone)
            case .yyyy:
                Date.ParseStrategy(format: "..\(year: .padded(4))", locale: locale, timeZone: timeZone)
            case .ddmm:
                Date.ParseStrategy(format: "\(day: .twoDigits)/\(month: .twoDigits)/", locale: locale, timeZone: timeZone)
            case .mmyyyy:
                Date.ParseStrategy(format: "/\(month: .twoDigits)/\(year: .padded(4))", locale: locale, timeZone: timeZone)
            case .ddmmyyyy:
                Date.ParseStrategy(format: "\(day: .twoDigits)/\(month: .twoDigits)/\(year: .padded(4))", locale: locale, timeZone: timeZone)
            default: nil
        }
    }

    public var timeParseStrategy: Date.ParseStrategy {
        Date.ParseStrategy(format: "\(hour: .defaultDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits)", locale: locale, timeZone: timeZone)
    }
}
