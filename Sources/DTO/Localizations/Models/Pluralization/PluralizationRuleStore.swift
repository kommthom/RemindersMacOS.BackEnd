import Foundation

public struct PluralizationRuleStore {
    public static func pluralizationRule(forLocale locale: Localizations.LocalizationIdentifier) -> PluralizationRule? {
        if let exactPluralizationRule = self.allPluralizationRulesMap[locale] { return exactPluralizationRule }
        /// If exact `PluralizationRule` is not found (exact meaning that both language
        /// and country match), fall back to matching only language code as the pluralization
        /// rules almost never differ between countries for the same language.
        if locale.hasCountryCode { return self.pluralizationRule(forLocale: locale.languageCode) }
        return nil
    }
    
    public static func availablePluralCategories(forLocale locale: Localizations.LocalizationIdentifier) -> [PluralCategory] {
        return self.pluralizationRule(forLocale: locale)?.availablePluralCategories ?? []
    }
}

private extension PluralizationRuleStore {
    /// Returns a map of all LocaleIdentifiers to it's PluralizationRules for a faster access
    static let allPluralizationRulesMap: [Localizations.LocalizationIdentifier: PluralizationRule] = {
        var rulesMap = [Localizations.LocalizationIdentifier: PluralizationRule]()
        for rule in PluralizationRuleStore.all {
            rulesMap[rule.locale] = rule
        }
        return rulesMap
    }()
}
