//
//  ConfigurationError.swift
//
//
//  Created by Thomas Benninghaus on 12.01.24.
//

import Foundation

public enum ConfigurationError: Error {
    case localizationNotFound(String)
    case localizationNotReadable(String)
    case templatePathNotFound(String)
    case templatePathNotReadable(String)
    case publicDirectoryNotFound(String)
    case publicDirectoryNotReadable(String)
    case isNotSQLDatabase
}

