//
//  Constants.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Foundation

public struct Constants {
    /// How long should access tokens live for. Default: 15 minutes (in seconds)
    public static let ACCESS_TOKEN_LIFETIME: Double = 60 * 15
    /// How long should refresh tokens live for: Default: 7 days (in seconds)
    public static let REFRESH_TOKEN_LIFETIME: Double = 60 * 60 * 24 * 7
    /// How long should the email tokens live for: Default 24 hours (in seconds)
    public static let EMAIL_TOKEN_LIFETIME: Double = 60 * 60 * 24
    /// Lifetime of reset password tokens: Default 1 hour (seconds)
    public static let RESET_PASSWORD_TOKEN_LIFETIME: Double = 60 * 60
    
    public static let projectsRootName: String = "root project"
    public static let projectsArchiveName: String = "archive"
    public static let projectsNoProjectName: String = "no project"
    public static let projectsDemoProjectName: String = "demo project no."
    public static let projectsDemoTaskName: String = "demo task no."
}
