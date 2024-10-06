//
//  HistoryControllerError.swift
//  
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Fluent
import Vapor

enum HistoryControllerError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingHistory
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}

