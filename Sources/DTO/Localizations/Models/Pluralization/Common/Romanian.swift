import Foundation

/// Used for Moldavian, Romanian.
public class Romanian: AbstractPluralizationRule {
    public let availablePluralCategories: [PluralCategory] = [.one, .few, .other]
    
    public func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        if n == 1 { return .one }
        if n == 0 || (1...19).contains(n % 100) { return .few }
        return .other
    }
}
