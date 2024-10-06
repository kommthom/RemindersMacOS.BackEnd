//
//  LocaleFormattingProtocol.swift
//
//
//  Created by Thomas Benninghaus on 21.05.24.
//

import Foundation

public protocol LocaleFormattingProtocol {
    var locale: Locale { get }
    var timeZone: TimeZone { get }
    var timeParseStrategy: Date.ParseStrategy { get }
    func dateParseStrategy(formatType: CustomDateFormatType) -> Date.ParseStrategy?
}

public extension LocaleFormattingProtocol {
    func formatDate(_ date: Date) -> String {
        return date.formatted(.dateTime
            .day(.twoDigits)
            .month(.twoDigits)
            .year(.extended())
            .locale(self.locale))
    }
    
    func formatTime(_ time: Date) -> String {
        return time.formatted(.dateTime
            .hour(.twoDigits(amPM: .abbreviated))
            .minute(.twoDigits)
            .locale(self.locale))
    }
    
    func weekDay(_ date: Date) -> String {
        return date.formatted(.dateTime
            .weekday(.wide)
            .locale(self.locale))
    }
}
