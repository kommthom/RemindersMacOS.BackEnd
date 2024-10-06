//
//  CustomDateFormatType.swift
//
//
//  Created by Thomas Benninghaus on 04.04.24.
//

import Foundation

public enum CustomDateFormatType: Codable, CaseIterable {
    case hh, hhmm, d, dd, ddd, w, ww, mm, yyyy, dmm, ddmm, dw, dww, wmm, wwyyyy, mmyyyy, dwmm, dwwyyyy, dmmyyyy, dddyyyy, ddmmyyyy, wmmyyyy, dwmmyyyy, none
    
    public var weekType: TypeOfWeekNo? {
        switch self {
            case .hh, .hhmm, .d, .dd, .ddd, .mm, .yyyy, .dmm, .ddmm, .mmyyyy, .dmmyyyy, .dddyyyy, .ddmmyyyy, .none: nil
            case .w, .dw, .wmm, .dwmm, .wmmyyyy: .ofMonth
            case .ww, .dww, .wwyyyy, .dwwyyyy, .dwmmyyyy: .ofYear
        }
    }
    
    public var dayType: TypeOfDayNo? {
        switch self {
            case .dd, .ddmm, .ddmmyyyy: .ofMonth
            case .hh, .hhmm, .w, .ww, .mm, .yyyy, .wmm, .wwyyyy, .mmyyyy, .wmmyyyy, .none: nil
            case .d, .dw, .dww, .dmm, .dwmm, .dwwyyyy, .dmmyyyy, .dwmmyyyy: .ofWeek
            case .ddd, .dddyyyy: .ofYear
        }
    }
    
    public var calculatorType: DateComponent? {
        switch self {
            case .hhmm: .quarterHour
            case .hh: .hour
            case .d, .dd, .ddmm, .dw, .dww, .dmm, .dwmm, .ddd, .dddyyyy, .dwwyyyy, .dmmyyyy, .dwmmyyyy, .ddmmyyyy: .day
            case .w, .ww, .wmm, .wwyyyy, .wmmyyyy: .week
            case .mm, .mmyyyy: .month
            case .yyyy: .year
            case .none: nil
        }
    }
    
    public var isStandardDateType: Bool {
        switch self {
            case .hhmm, .dd, .mm, .yyyy, .ddmm, .mmyyyy, .ddmmyyyy: true
            default: false
        }
    }
}
