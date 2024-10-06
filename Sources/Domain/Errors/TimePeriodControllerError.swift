//
//  TimePeriodControllerError.swift
//
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Fluent
import Vapor

enum TimePeriodControllerError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingTimePeriod
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
