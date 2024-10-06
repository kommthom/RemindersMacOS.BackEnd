import Foundation

public final class tzm: PluralizationRule {
    public let locale: Localizations.LocalizationIdentifier = "tzm"
    public let availablePluralCategories: [PluralCategory] = [.one, .other]
    
    public func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        if (0...1).contains(n) || (11...99).contains(n) { return .one } else { return .other }
    }
}
