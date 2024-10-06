import Foundation

public final class ar: PluralizationRule {
    public let locale: Localizations.LocalizationIdentifier = "ar"
    
    public var availablePluralCategories: [PluralCategory] = [.zero, .one, .two, .few, .many, .other]
    
    public func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        let mod100 = n % 100
        
        if n == 0 { return .zero } else
        if n == 1 { return .one } else
        if n == 2 { return .two } else
        if (3...10).contains(mod100) { return .few } else
        if (11...99).contains(mod100) { return .many } else { return .other }
    }
    
}
