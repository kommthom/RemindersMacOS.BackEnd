//
//  ParsableComponentType.swift
//
//
//  Created by Thomas Benninghaus on 25.03.24.
//

import Foundation

public enum ParsableComponentType {
    case keyword(findKeyWord: (_ locale: KeyWords.LocalizationIdentifier, _ rawValue: String) -> KeyWord?)
    case int
    case date(_ dateParseStrategies: [CustomDateFormatType: Date.ParseStrategy])
    case time(_ strategy: Date.ParseStrategy)
    //case day
    //case monthDay
    //case month
    //case yearMonth
    //case year
    //case yearMonthDay
    case dateRelative(_ strategy: DateRelative.ParseStrategy)
    case month(_ localizedMonthNames: [String], _ shortMonthNames: [String])
    case weekday(_ localizedWeekdayNames: [String], _ shortWeekdayNames: [String])
    case composite(
        _ findKeyWord: (_ locale: KeyWords.LocalizationIdentifier, _ rawValue: String) -> KeyWord?, parsableComponentTypes: [ParsableComponentType]? = nil,
        _ dateParseStrategies: [CustomDateFormatType: Date.ParseStrategy],
        _ timeParseStrategy: Date.ParseStrategy,
        _ localizedNames: [String: [String]]
    )
    //case repetitionArgument
    case other
    
    public var description: String { String(describing: self) }
}

extension Predicate where Target == ParsableComponentType {
    public static func isComposite() -> Self {
        Predicate {
            return switch $0 {
                case .composite: true
                //case .repetitionArgument: true
                default: false
            }
        }
    }
    public static func isSimple() -> Self {
        Predicate {
            return switch $0 {
                case .composite, .other: false
                //case .repetitionArgument : false
                default: true
            }
        }
    }
    /*public static func isForReduced() -> Self {
        Predicate {
            return switch $0 {
                case .keyword(_), .composite(_, _, _, _), .other: false
                //case .repetitionArgument: false
                default: true
            }
        }
    }*/
}
