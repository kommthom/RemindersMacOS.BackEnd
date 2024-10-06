//
//  CompositeString.swift
//
//
//  Created by Thomas Benninghaus on 27.04.24.
//

import Foundation

public struct CompositeString: RawRepresentable {
    public typealias RawValue = String
    
    public var rawValue: RawValue
    public var prefix: String
    public var suffixes: [String]
    
    public init?(rawValue: RawValue) {
        self.rawValue = rawValue
        let split = rawValue.split(maxSplits: 1, omittingEmptySubsequences: true, whereSeparator: { $0 == "(" || $0 == ")" } )
        switch split.count {
            case 1: prefix = String(split[0]); suffixes = .init()
        case 2: prefix = String(split[0]); suffixes = split[1].replacing(" ", with: "").split(separator: ",", omittingEmptySubsequences: true).map { $0 == "." ? "" : String( $0 ) }
            default: return nil
        }
    }
}

public typealias CompositeStringDictionaryElement = Dictionary<AnyHashable, CompositeString>.Element

extension Predicate where Target == CompositeStringDictionaryElement {
    public static func hasPrefix(comparedTo string: String) -> Self {
        Predicate { return string.hasPrefix($0.value.prefix) }
    }
        
    public static func hasSuffix(comparedTo string: String) -> Self {
        Predicate { return $0.value.suffixes.contains("?") || $0.value.suffixes.contains(string.eliminatePrefix($0.value.prefix)!) }
    }
    
    public static func equals(comparedTo string: String) -> Self {
        Predicate {
            if string.hasPrefix($0.value.prefix) {
                return $0.value.suffixes.contains("?") ||
                $0.value.suffixes.contains(string.eliminatePrefix($0.value.prefix)!)
            } else { return false }
        }
    }
}
