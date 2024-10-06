//
//  ProjectControllerError.swift
//
//
//  Created by Thomas Benninghaus on 24.12.23.
//

import Vapor

enum ProjectControllerError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingProject
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
