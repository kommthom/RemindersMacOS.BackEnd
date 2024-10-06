import Foundation

public final class gd: PluralizationRule {
    public let locale: Localizations.LocalizationIdentifier = "gd"
    public let availablePluralCategories: [PluralCategory] = [.one, .two, .few, .other]
    
    public func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        if n == 1 || n == 11 { return .one } else 
        if n == 2 || n == 12 { return .two } else
        if  (3...10).contains(n) || (13...19).contains(n) { return .few } else { return .other }
    }
}
