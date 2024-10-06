//
//  LocationControllerError.swift
//
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Fluent
import Vapor

enum LocationControllerError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingLocation
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
