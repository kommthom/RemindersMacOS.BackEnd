import Foundation

public class OneUptoTwoOther: AbstractPluralizationRule {
    public let availablePluralCategories: [PluralCategory] = [.one, .other]
    
    public func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        return n >= 0 && n < 2 ? .one : .other
    }
}
