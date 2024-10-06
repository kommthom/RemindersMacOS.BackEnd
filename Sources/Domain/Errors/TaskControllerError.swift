//
//  TaskControllerError.swift
//
//
//  Created by Thomas Benninghaus on 08.02.24.
//

import Vapor

enum TaskControllerError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingTask
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
