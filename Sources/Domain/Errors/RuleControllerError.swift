//
//  RuleControllerError.swift
//  
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Fluent
import Vapor

enum RuleControllerError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingRule
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
