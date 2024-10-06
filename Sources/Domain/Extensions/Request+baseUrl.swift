//
//  Request+baseUrl.swift
//
//
//  Created by Thomas Benninghaus on 02.05.24.
//

import Vapor

public extension Request {
    var baseUrl: String {
        let configuration = application.http.server.configuration
        let scheme = configuration.tlsConfiguration == nil ? "http" : "https"
        let host = configuration.hostname
        let port = configuration.port
        return "\(scheme)://\(host):\(port)"
    }
}
