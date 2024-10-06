//
//  RepetitionControllerError.swift
//  
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Fluent
import Vapor

enum RepetitionControllerError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingRepetition
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
