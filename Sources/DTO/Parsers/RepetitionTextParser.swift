//
//  RepetitionTextParser.swift
//
//
//  Created by Thomas Benninghaus on 23.03.24.
//

import Foundation

public struct RepetitionTextParser: CompositeStringParserProtocol {
    public var locale: LocaleIdentifier
    public var useParsers: [any StringComponentParserProtocol]
    
    public init(locale: LocaleIdentifier, useParsers: [any StringComponentParserProtocol]) {
        self.locale = locale
        self.useParsers = useParsers
    }
    
    public init(locale: LocaleIdentifier, findKeyWord: @escaping (_ locale: KeyWords.LocalizationIdentifier, _ rawValue: String) -> KeyWord?) {
        let factory = TextParserFactory(locale: locale)
        self.init(locale: locale, useParsers: ParsableComponentTypes(findKeyWord: findKeyWord).filtered(matching: .isSimple()).compactMap { factory.create(typeOfParser: $0) } )
    }
    
    public func parse(input: ParsedComponent) -> ParsedComponent {
        let factory = TextParserFactory(locale: locale)
        var parsedComponents = ParsedComponents(components: [input])
        for parser in useParsers {
            parsedComponents = factory.createArray(parser: parser)!.parse(input: parsedComponents)
        }
        return ParsedComponent(stringValue: input.stringValue, parsedValue: .composite(parsedComponents))
    }
    
    public static func unwrap(input: ParsedComponent) -> ParsedComponents {
        return switch input.parsedValue {
            case .composite(let components): components
            //case .repetitionArgument(let components): components
            default: ParsedComponents(components: [input])
        }
    }
}
