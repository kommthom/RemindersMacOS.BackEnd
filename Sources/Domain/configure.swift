//
//  configure.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import Fluent
import Leaf
import QueuesRedisDriver
import Resources
import DTO

/// Called at the start up of the Vapor app.
public func configure(_ app: Application) throws {
    // MARK: JWT
    try jwt(app)
    
    // MARK: Host URL and port
    setHostConfiguration(app)
    
    // MARK: Database
    app.databases.use(DatabaseConfigurationFactory.environmental, as: .sqlite)

    // MARK: Middleware
    app.middleware = .init()
    // Serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.routes.defaultMaxBodySize = "10mb"
    app.middleware.use(ErrorMiddleware.custom(environment: app.environment))
    
    app.sessions.use(.fluent)
    app.sessions.configuration.cookieName = "remindersmacos"
    app.migrations.add(SessionRecord.migration)
    app.middleware.use(app.sessions.middleware)
    app.middleware.use(UserSessionAuthenticator())
    app.middleware.use(UserJWTAuthenticator())
    
    // MARK: Environment checks
    try checkEnvironment(app)
    
    // MARK: SmtpTool
    app.smtp.configuration = .environment
    
    // MARK: App Config
    app.config = .environment
    
    app.views.use(.leaf)
    app.leaf.tags["localize"] = LocalizeTag()
    app.leaf.tags["locale"] = LocaleTag()
    app.leaf.tags["localeLinks"] = LocaleLinksTag()

    try routes(app)
    try migrations(app)
    try queues(app)
    try services(app)
    
    
    if app.environment == .development {
        try app.autoMigrate().wait()
        try app.queues.startInProcessJobs()
    }
}

private func checkEnvironment(_ app: Application) throws {
    var boolValue: ObjCBool = true
    if FileManager.default.fileExists(atPath: app.directory.publicDirectory, isDirectory: &boolValue) {
        if FileManager.default.isReadableFile(atPath: app.directory.publicDirectory.appending("/Styles/Menu.css")) {
            app.logger.info("Public Directory: \(app.directory.publicDirectory)")
        } else {
            app.logger.error("Public Directory files at \(app.directory.publicDirectory) not readable")
            throw ConfigurationError.publicDirectoryNotReadable(app.directory.publicDirectory)
        }
    } else {
        app.logger.error("Public Directory \(app.directory.publicDirectory) does not exist")
        throw ConfigurationError.publicDirectoryNotFound(app.directory.publicDirectory)
    }
    
    var remainingKeys = Set(NeededEnvironmentVariables.allCases)
    let envVars: EnvironmentVariables<NeededEnvironmentVariables> = EnvironmentVariables<NeededEnvironmentVariables> {
        guard let key = NeededEnvironmentVariables(rawValue: $0) else {
            app.logger.error("\($0) is not a valid environment key")
            return nil
        }
        guard remainingKeys.remove(key) != nil else {
            app.logger.error("Matched key \(key) multiple times")
            return nil
        }
        return key.rawValue.uppercased()
    }
    if !remainingKeys.isEmpty {
        app.logger.error("Remaining environment keys: \(remainingKeys)")
    }
    try envVars.assertKeys()
    for key in NeededEnvironmentVariables.allCases {
        let envKey = key.rawValue.uppercased()
        let envValue: String = try Environment.get(envKey) ?? envVars.get(key)
        app.logger.info("\(envKey): \(envValue)")
    }
    
    if FileManager.default.fileExists(atPath: ResourcePaths.localizationsPath.path, isDirectory: &boolValue) {
        if FileManager.default.isReadableFile(atPath: ResourcePaths.localizationsPath.appendingPathComponent("\(LanguageIdentifier.en.code).json").path()) {
            app.logger.info("Localization path: \(ResourcePaths.localizationsPath)")
        } else {
            app.logger.error("Localization files at \(ResourcePaths.localizationsPath) not readable")
            throw ConfigurationError.localizationNotReadable(ResourcePaths.localizationsPath.path)
        }
    } else {
        app.logger.error("Localization path \(ResourcePaths.localizationsPath) does not exist")
        throw ConfigurationError.localizationNotFound(ResourcePaths.localizationsPath.path)
    }
    if FileManager.default.fileExists(atPath: ResourcePaths.htmlTemplatesPath.path, isDirectory: &boolValue) {
        if FileManager.default.isReadableFile(atPath: ResourcePaths.htmlTemplatesPath.appendingPathComponent("\(EmailTemplateType.verificationEmail.templateName).html").path) {
            app.logger.info("Email template path: \(ResourcePaths.htmlTemplatesPath)")
        } else {
            app.logger.error("Email template files at \(ResourcePaths.htmlTemplatesPath) not readable")
            throw ConfigurationError.templatePathNotReadable(ResourcePaths.htmlTemplatesPath.path)
        }
    } else {
        app.logger.error("Email template path \(ResourcePaths.htmlTemplatesPath) does not exist")
        throw ConfigurationError.templatePathNotFound(ResourcePaths.htmlTemplatesPath.path)
    }
    app.logger.info("Views directory: \(app.directory.viewsDirectory)")
    if FileManager.default.fileExists(atPath: ResourcePaths.leafTemplatesPath.path, isDirectory: &boolValue) {
        if FileManager.default.isReadableFile(atPath: ResourcePaths.leafTemplatesPath.appendingPathComponent("\(EmailTemplateType.verificationEmail.templateName).leaf").path) {
            app.logger.info("Email template path: \(ResourcePaths.leafTemplatesPath)")
            app.directory.viewsDirectory = ResourcePaths.leafTemplatesPath.path
        } else {
            app.logger.error("Email template files at \(ResourcePaths.leafTemplatesPath) not readable")
            throw ConfigurationError.templatePathNotReadable(ResourcePaths.leafTemplatesPath.path)
        }
    } else {
        app.logger.error("Email template path \(ResourcePaths.leafTemplatesPath) does not exist")
        throw ConfigurationError.templatePathNotFound(ResourcePaths.leafTemplatesPath.path)
    }
}

private func jwt(_ app: Application) throws {
    //if app.environment != .testing {
        guard let jwksString = Environment.get("SECRET_FOR_JWT") else {
            fatalError("Failed to load JWKS Keypair from environment SECRET_FOR_JWT")
        }
        try app.jwt.signers.use(jwksJSON: jwksString)
    //}
}

private func setHostConfiguration(_ app: Application) {
    app.logger.info("Set host configuration: \(String(describing: Environment.get("SITE_FRONTEND_URL"))):\(String(describing: Environment.get("SITE_FRONTEND_PORT")))")
    guard let hostName: String = Environment.get("SITE_FRONTEND_URL") else {
        fatalError("Failed to get HTTP-Server URL from environment SITE_FRONTEND_URL")
    }
    if hostName != "127.0.0.1" {
        app.http.server.configuration.hostname = hostName
    }
    guard let port: Int = Int(Environment.get("SITE_FRONTEND_PORT") ?? "8080") else {
        fatalError("Failed to get HTTP-Server port from environment SITE_FRONTEND_PORT")
    }
    if port != 8080 {
        app.http.server.configuration.port = port
    }
}

private func routes(_ app: Application) throws {
    app.logger.info("Configure routes")
    try! app.register(collection: UploadController())
    try! app.register(collection: AttachmentController())
    try! app.register(collection: AuthenticationController())
    try! app.register(collection: HistoryController())
    try! app.register(collection: TaskController())
    try! app.register(collection: ProjectController())
    try! app.register(collection: RepetitionController())
    try! app.register(collection: RuleController())
    try! app.register(collection: SettingController())
    try! app.register(collection: TagController())
    try! app.register(collection: TimePeriodController())
    try! app.register(collection: UserController())
    try! app.register(collection: WelcomeController())
}

private func migrations(_ app: Application) throws {
    // Initial Migrations
    app.logger.info("Add migrations")
    app.migrations.add(CreateCountry())
    app.migrations.add(CreateLocation())
    app.migrations.add(CreateLanguage())
    app.migrations.add(CreateLocale())
    app.migrations.add(CreateCountryLocale())
    app.migrations.add(CreateLocation())
    app.migrations.add(CreateUser())
    app.migrations.add(CreateBasicDataContent())
    app.migrations.add(CreateRefreshToken())
    app.migrations.add(CreateEmailToken())
    app.migrations.add(CreatePasswordToken())
    app.migrations.add(CreateAttachment())
    app.migrations.add(CreateUpload())
    app.migrations.add(CreateHistory())
    app.migrations.add(CreateRepetition())
    app.migrations.add(CreateRule())
    app.migrations.add(CreateTaskRule())
    app.migrations.add(CreateSetting())
    app.migrations.add(CreateTag())
    app.migrations.add(CreateTaskTag())
    app.migrations.add(CreateTimePeriod())
    app.migrations.add(CreateRepetitionTimePeriod())
    app.migrations.add(CreateProject())
    app.migrations.add(CreateTask())
}

private func queues(_ app: Application) throws {
    // MARK: Queues Configuration
    //if app.environment != .testing {
        app.logger.info("Initialize queues")
        try app.queues.use(
            .redis(.init(url:
                Environment.get("REDIS_URL") ?? "redis://127.0.0.1:6379",
                   pool: .init(connectionRetryTimeout: .seconds(60)))
            )
        )
    //}
    // MARK: Jobs
    app.queues.add(EmailJob())
}

private func services(_ app: Application) throws {
    app.logger.info("Initialize services")
    app.randomGenerators.use(.random)
    app.repositories.use(.database)
    app.localizations.use(.localization)
}
