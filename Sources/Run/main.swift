//
//  main.swift
//  Presentation
//
//  Created by Thomas Benninghaus on 21.12.23.
//

import Domain
import Vapor

/// This application is start here🏃‍♂️
    var env = try Environment.detect()
    try LoggingSystem.bootstrap(from: &env)
    let app = Application(env)
    defer { app.shutdown() }
    try configure(app)
    try app.run()
