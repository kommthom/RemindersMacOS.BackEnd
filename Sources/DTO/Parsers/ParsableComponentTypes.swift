//
//  ParsableComponentTypes.swift
//  
//
//  Created by Thomas Benninghaus on 29.03.24.
//

import Foundation

public struct ParsableComponentTypes {
    private var parsableComponentTypes: [ParsableComponentType]

    public init(findKeyWord: @escaping (_ locale: KeyWords.LocalizationIdentifier, _ rawValue: String) -> KeyWord?, parsableComponentTypes: [ParsableComponentType]? = nil,
                dateParseStrategies: [CustomDateFormatType: Date.ParseStrategy],
                timeParseStrategy: Date.ParseStrategy,
                localizedNames: [String: [String]]
    ) {
        self.parsableComponentTypes = [
            .keyword(findKeyWord: findKeyWord),
            .int, 
            .date(dateParseStrategies),
            .time(timeParseStrategy),
            .dateRelative,
            .month(localizedNames["localizedMonthNames"] ?? Month.allCases.compactMap( { $0.rawValue } ), localizedNames["shortMonthNames"] ?? []),
            .weekday(localizedNames["localizedWeekdayNames"] ?? Weekday.allEnum, localizedNames["shortWeekdayNames"] ?? []),
            .composite(findKeyWord, dateParseStrategies, timeParseStrategy, localizedNames),
            //.int, .day, .time, .monthDay, .month, .yearMonth, .year, .yearMonthDay, .dateRelative, .weekday, .composite(findKeyWord: findKeyWord),
            //.repetitionArgument,
            .other ]
    }
}

extension ParsableComponentTypes {
    func filtered(matching predicate: Predicate<ParsableComponentType>) -> [ParsableComponentType] {
        parsableComponentTypes.filter(predicate.matches)
    }
}
