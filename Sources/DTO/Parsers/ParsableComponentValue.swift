//
//  ParsableComponentValue.swift
//  
//
//  Created by Thomas Benninghaus on 25.03.24.
//

import Foundation

public enum ParsableComponentValue {
    case keyword(_ keyword: KeyWord)
    case int(_ value: Int)
    case date(_ dMy: DateRelative)
    case time(_ date: Date)
    //case day(_ date: Date)
    //case monthDay(_ month: Int, _ day: Int)
    //case month(_ month: Int)
    //case year(_ year: Int)
    //case yearMonth(_ year: Int, _ month: Int)
    //case yearMonthDay(_ year: Int, _ month: Int, _ day: Int)
    case dateRelative(_ dMy: DateRelative)
    case month(_ month: Int)
    case weekday(_ weekday: Weekday)
    case composite(_ components: ParsedComponents)
    //case repetitionArgument(_ components: ParsedComponents)
    case other(_ name: String)
    
    public var description: String { String(describing: self) }
    /*
    public var correspondingType: ParsableComponentType {
        switch self {
            case .keyword(_): .keyword { locale, rawValue in nil }
            case .int(_): .int
            case .date(_):  .date(<#T##Date.ParseStrategy#>)
            case .time(_): .time(<#T##Date.ParseStrategy#>)
            //case .day(_):  .day
            //case .monthDay(_, _): .monthDay
            //case .month(_): .month
            //case .yearMonth(_, _): .yearMonth
            //case .yearMonthDay(_, _, _): .yearMonthDay
            //case .year(_): .year
            case .dateRelative(_): .dateRelative
            case .month(_): .month
            case .weekday(_): .weekday
            case .composite(_): .composite
            //case .repetitionArgument(_): .repetitionArgument
            case .other(_): .other
        }
    }
    */
    public var unwrap: ParsedComponents {
        return switch self {
            case .composite(let components): components
            //case .repetitionArgument(let components): components
            default: ParsedComponents(components: [ParsedComponent(stringValue: self.description, parsedValue: self)])
        }
    }
    
    public var keyword: KeyWord? { self[keyPath: \.keyword] }
}
