//
//  UploadControllerError.swift
//
//
//  Created by Thomas Benninghaus on 01.05.24.
//

import Fluent
import Vapor

enum UploadControllerError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingUpload
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}

