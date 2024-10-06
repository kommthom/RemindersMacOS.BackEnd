//
//  DTOConstants.swift
//  
//
//  Created by Thomas Benninghaus on 26.03.24.
//

import Foundation

public struct DTOConstants {
    public static var shared: DTOConstants.Shared { DTOConstants.Shared() }
    public static var `default`: DTOConstants.Default { DTOConstants.Default() }
    public struct Shared {
        public let argumentsSeparator = " "
        public let listSeparator = ", "
        public let timeSeparator = ":"
        public let dot = "."
        public let slash = "/"
        public let minus = "-"
    }
    public struct Default {
        public var localeIdentifier: LocaleIdentifier { locale.identifier }
        public var languageIdentifier: LanguageIdentifier { language.identifier }
        public var timeZone = TimeZone(identifier: "UTC")
        public var language: LanguageDTO { locale.language }
        public var locale = LocaleDTO(
              name: "Default Locale",
              identifier: .de_DE,
              longName: "default locale de_DE",
              timeFirst: false,
              timeSeparator: .colon,
              timeZoneSeparator: .omitted,
              dateSeparator: .dot,
              dateTimeSeparator: .space,
              timeFormatString: "",
              standardDateFormatString: "",
              dateFormatString: "",
              language: LanguageDTO(name: "german", identifier: .de, longName: "Deutsch", locales: LocalesDTO(locales: []), localization: { _ in "not implemented"} ),
              localization: { _ in "not implemented" } )
    }
}
