//
//  TagControllerError.swift
//  
//
//  Created by Thomas Benninghaus on 08.02.24.
//

import Fluent
import Vapor

enum TagControllerError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingTag
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
