//
//  TextLocalization.swift
//
//
//  Created by Thomas Benninghaus on 09.01.24.
//

import Lingo
import Foundation
import RegexBuilder

public struct TextLocalization: TextLocalizationProtocol {
    private let inputString: String
    private let textConverter: TextConverter?
    private var localization: LocalizationProtocol
    
    public init(inputString: String, localization: LocalizationProtocol, textConverter: TextConverter?) {
        self.inputString = inputString
        self.localization = localization
        self.textConverter = textConverter
    }
    
    public func localize(languageCode: LocaleIdentifier = "en", interpolations: [String: String]? = nil) -> String {
        var translatedString: String = inputString
        let newDict = getDictionaryValues(languageCode: languageCode, interpolations: interpolations)
        for replaceKey in newDict.keys {
            print("Replacing ${\(replaceKey)} with: \(newDict[replaceKey]!)")
            translatedString = translatedString.replacingOccurrences(of: "${\(replaceKey)}", with: newDict[replaceKey]!)
        }
        return translatedString
    }
    
    private func getInterpolations(from: String) -> [String] {
        var interpolations: [String] = []
        let regex = Regex {
            /*not supported! Regex {
                Lookbehind {
                    "${"
                }
            }*/
            /\$\{/
            Capture {
                /[^$]{1,}/
            }
            /(?=\})/
        } //"/(?<=\\$\\{)[^$]{1,}(?=\\})/g"
        let matches = from.matches(of: regex)
        for match in matches {
            let dictEntry = "\(match.output.1)"
            print(dictEntry)
            interpolations.append(dictEntry)
        }
        return interpolations
    }
    
    private func getDictionaryValues(languageCode: LocaleIdentifier, interpolations: [String: String]?) -> [String: String] {
        var newDict: [String: String] = [:]
        var replaceValue: String
        
        for replaceKey in getInterpolations(from: inputString) {
            replaceValue = localization.localize(replaceKey, locale: languageCode, interpolations: interpolations)
            newDict[replaceKey] = replaceKey.lowercased().contains("url") ? replaceValue : textConverter?(replaceValue) ?? replaceValue
        }
        return newDict
    }
}

