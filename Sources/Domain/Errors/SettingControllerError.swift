//
//  SettingControllerError.swift
//
//
//  Created by Thomas Benninghaus on 03.02.24.
//

import Fluent
import Vapor

enum SettingControllerError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingSetting
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
