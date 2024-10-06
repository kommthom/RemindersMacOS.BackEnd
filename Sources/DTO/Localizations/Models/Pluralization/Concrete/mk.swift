import Foundation

public final class mk: PluralizationRule {
    public let locale: Localizations.LocalizationIdentifier = "mk"
    public let availablePluralCategories: [PluralCategory] = [.one, .other]
    
    public func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        if n % 10 == 1 && n != 11 { return .one } else { return .other }
    }
}
