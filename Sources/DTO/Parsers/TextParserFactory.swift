//
//  TextParserFactory.swift
//  
//
//  Created by Thomas Benninghaus on 28.03.24.
//

import Foundation

public struct TextParserFactory {
    public func create(typeOfParser: ParsableComponentType) -> StringComponentParserProtocol? {
        return switch typeOfParser {
            case .keyword(let findKeyWord): StringKeyWordParser(locale: locale, findKeyWord: findKeyWord)
            case .int(let strategy): StringIntParser(locale: locale)
            case .time(let strategy): StringToTimeParser(strategy: strategy)
            //case .day: StringDayParser(locale: locale)
            //case .monthDay: StringMonthDayParser(locale: locale)
            //case .month: StringMonthParser(locale: locale)
            //case .weekday: StringWeekdayParser(locale: locale)
            //case .yearMonth: StringYearMonthParser(locale: locale)
            //case .year: StringYearParser(locale: locale)
            //case .yearMonthDay: StringYearMonthDayParser(locale: locale)
            case .date(let strategy): StringDateParser(strategy: strategy)
            case .month(let localizedMonthNames, let shortMonthNames): StringMonthParser(localizedMonthNames: localizedMonthNames, shortMonthNames: shortMonthNames)
            case .dateRelative: StringDayMonthYearParser(locale: locale)
            case .composite(_): nil
            //case .repetitionArgument: nil
            case .other: nil
            //default: nil
        }
    }
    
    public func createArray(parser: StringComponentParserProtocol) -> StringArrayParserProtocol? {
        return StringArrayParser(useParser: parser)
    }
    
    public func createComposite(typeOfParser: ParsableComponentType) -> CompositeStringParserProtocol? {
        switch typeOfParser {
            case .composite(let findKeyWord):
                let parsers = ParsableComponentTypes(findKeyWord: findKeyWord).filtered(matching: .isSimple()).compactMap { self.create(typeOfParser: $0) }
                return RepetitionTextParser(locale: locale, useParsers: parsers)
            //case .repetitionArgument:
            //    let parsers = ParsableComponentTypes().filtered(matching: .isForReduced()).compactMap { self.create(typeOfParser: $0) }
            //    return RepetitionArgumentParser(useParsers: parsers)
            default: return nil
        }
    }
}
