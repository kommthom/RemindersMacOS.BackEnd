//
//  ModelType.swift
//
//
//  Created by Thomas Benninghaus on 16.05.24.
//

import Foundation

public enum ModelType: String, CustomStringConvertible, CaseIterable, Codable {
    case attachments = "attachments"
    case countries = "countries"
    case emailtokens = "emailtokens"
    case histories = "histories"
    case languages = "languages"
    case locales = "locales"
    case localizations = "localizations"
    case locations = "locations"
    case passwordtokens = "passwordtokens"
    case projects = "projects"
    case refreshtokens = "refreshtokens"
    case repetitions = "repetitions"
    case rules = "rules"
    case settings = "settings"
    case tags = "tags"
    case tasks = "tasks"
    case timeperiods = "timeperiods"
    case uploads = "uploads"
    case users = "users"
    case keywords = "keywords"
    case actiontypes = "actiontypes"
    case attachmenttypes = "attachmenttypes"
    case customdateformattypes = "customdateformattypes"
    case historytypes = "historytypes"
    case intervalkeywords = "intervalkeywords"
    case keywordtypes = "keywordtypes"
    case languageidentifiers = "languageidentifiers"
    case localeidentifiers = "localeidentifiers"
    case localizationenums = "localizationenums"
    case localizationresults = "localizationresults"
    case notificationtypes = "notificationtypes"
    case priorities = "priorities"
    case ruletypes = "ruletypes"
    case scopetypes = "scopetypes"
    case settingvaluetypes = "settingvaluetypes"
    
    public var description: String { self.rawValue }
    
    public var isLocalizable: Bool {
        switch self {
            case .countries, .languages, .locales, .locations, .projects, .rules, .settings, .tags: true
            default: false
        }
    }
    
    public var isLocalization: Bool {
        switch self {
        case .users, .locales, .languages, .keywords: true
            default: false
        }
    }
    
    public var isTable: Bool {
        switch self {
            case .attachments, .countries, .emailtokens, .histories, .languages, .locales, .localizations, .locations, .passwordtokens, .projects, .refreshtokens, .repetitions, .rules, .settings, .tags, .tasks, .timeperiods, .uploads, .users:
                true
            default: false
        }
    }
    
    public var isEnum: Bool {
        switch self {
            case .attachments, .countries, .emailtokens, .histories, .languages, .locales, .localizations, .locations, .passwordtokens, .projects, .refreshtokens, .repetitions, .rules, .settings, .tags, .tasks, .timeperiods, .uploads, .users:
                false
            default: true
        }
    }
}

public struct ModelTypes {
    public var modelTypes: [ModelType]
    
    public init(modelTypes: [ModelType] = ModelType.allCases) {
        self.modelTypes = modelTypes
    }
    
    public var localizableModels: [ModelType] {
        modelTypes.filter { $0.isLocalizable }
    }
    
    public var localizationModels: [ModelType] {
        modelTypes.filter { $0.isLocalization }
    }
}
