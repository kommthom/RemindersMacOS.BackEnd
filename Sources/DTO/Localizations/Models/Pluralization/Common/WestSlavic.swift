import Foundation

/// Used for Czech, Slovak.
public class WestSlavic: AbstractPluralizationRule {
    public let availablePluralCategories: [PluralCategory] = [.one, .few, .other]
    
    public func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        if n == 1 { return .one }
        if (2...4).contains(n) { return .few }
        return .other
    }
}
