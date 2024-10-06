import Foundation

public class Other: AbstractPluralizationRule {
    public let availablePluralCategories: [PluralCategory] = [.other]
    
    public func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        return .other
    }
}
