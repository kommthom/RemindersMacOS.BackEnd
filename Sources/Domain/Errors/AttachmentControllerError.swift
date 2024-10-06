//
//  AttachmentControllerError.swift
//  
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Fluent
import Vapor

enum AttachmentControllerError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingAttachment
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
