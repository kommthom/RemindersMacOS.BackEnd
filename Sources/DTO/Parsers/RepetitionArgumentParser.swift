//
//  RepetitionArgumentParser.swift
//
//
//  Created by Thomas Benninghaus on 29.03.24.
//
/*
import Foundation

public struct RepetitionArgumentParser: CompositeStringParserProtocol {
    public var locale: LocaleIdentifier
    public var useParsers: [any StringComponentParserProtocol]
    
    public init(useParsers: [any StringComponentParserProtocol]) {
        self.locale = .notSet
        self.useParsers = useParsers
    }
    public init() {
        let factory = TextParserFactory(locale: .notSet)
        self.init(useParsers: ParsableComponentTypes().filtered(matching: .isForReduced()).compactMap { factory.create(typeOfParser: $0) } )
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
*/
