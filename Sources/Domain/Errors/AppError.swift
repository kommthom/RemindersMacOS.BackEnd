//
//  AppError.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor

public protocol AppError: AbortError, DebuggableError {}
