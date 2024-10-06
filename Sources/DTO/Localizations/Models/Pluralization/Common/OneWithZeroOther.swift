import Foundation

public class OneWithZeroOther: AbstractPluralizationRule {
    public let availablePluralCategories: [PluralCategory] = [.one, .other]
    
    public func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        return [0, 1].contains(n) ? .one : .other
    }
}
