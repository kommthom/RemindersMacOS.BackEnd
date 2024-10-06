import Foundation

public class OneOther: AbstractPluralizationRule {
    public func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        return n == 1 ? .one : .other
    }
    
    public let availablePluralCategories: [PluralCategory] = [.one, .other]
}
