//
//  Month.swift
//
//
//  Created by Thomas Benninghaus on 26.03.24.
//

import Foundation

public enum Month: String, CustomStringConvertible, CaseIterable {
    case january = "january"
    case february = "february"
    case march = "march"
    case april = "april"
    case may = "may"
    case june = "june"
    case july = "july"
    case august = "august"
    case september = " september"
    case october = "october"
    case november = "november"
    case december = "december"
    
    public init?(_ month: Int) {
        self.init(rawValue: Month.allCases[month - 1].rawValue)
    }
    
    public var description: String { self.rawValue }
    public var index: Int { return 1 + Month.allCases.firstIndex(of: self)! }
}
