//
//  LocaleValidator.swift
//
//
//  Created by Thomas Benninghaus on 13.05.24.
//

import Foundation

public final class LocaleValidator {
    public init() { }
    private static let validLocaleIdentifiers: Set<String> = {
        /// Make sure locales are in the correct format as per [RFC 5646](https://datatracker.ietf.org/doc/html/rfc5646)
        var correctedLocaleIdentifiers = Locale.availableIdentifiers.map { $0.replacingOccurrences(of: "_", with: "-") }
        /// Append missing locales not by default included
        correctedLocaleIdentifiers.append(contentsOf: ["zh-CN", "zh-HK", "zh-TW"])
        return Set(correctedLocaleIdentifiers)
    }()

    /// Checks if given locale is present in Locale.availableIdentifiers
    public func validate(locale: Localizations.LocalizationIdentifier) -> Bool {
        return LocaleValidator.validLocaleIdentifiers.contains(locale)
    }
}
