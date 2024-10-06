//
//  LocalizationControllerError.swift
//
//
//  Created by Thomas Benninghaus on 13.05.24.
//

import Foundation

public enum LocalizationControllerError: Error {
    case parsingFailure(message: String)
    case idParameterMissing
    case idParameterInvalid
    case missingLocalization
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
