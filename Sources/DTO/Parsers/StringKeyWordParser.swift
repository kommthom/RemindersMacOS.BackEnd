//
//  StringKeyWordParser.swift
//
//
//  Created by Thomas Benninghaus on 25.03.24.
//

import Foundation

public struct StringKeyWordParser: StringComponentParserProtocol {
    public var locale: LocaleIdentifier
    public var findKeyWord: (_ locale: KeyWords.LocalizationIdentifier, _ rawValue: String) -> KeyWord?
    
    public init(locale: LocaleIdentifier, findKeyWord: @escaping (_ locale: KeyWords.LocalizationIdentifier, _ rawValue: String) -> KeyWord?) {
        self.locale = locale
        self.findKeyWord = findKeyWord
    }
    
    public func parse(input: ParsedComponent) -> ParsedComponent {
        guard let keyWord = findKeyWord(locale.description, input.stringValue) else { return input }
        return ParsedComponent(stringValue: input.stringValue, parsedValue: .keyword(keyWord))
    }
}
