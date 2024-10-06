//
//  AuthenticationController.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import Fluent
import DTO

/// Controller For User processing
struct AuthenticationController: RouteCollection {
    /// The use case for authentication.
    private let useCase = AuthUseCase()
    private let logger = Logger(label: "reminders.backend.auth")
    
    func boot(routes: RoutesBuilder) throws {
        routes.group("api", "auth") { auth in
            auth.post("login", use: login)
            auth.post("logout", use: logout)
            auth.post("register", use: register)
            
            auth.group("email-verification") { emailVerificationRoutes in
                emailVerificationRoutes.post("", use: sendEmailVerification)
                emailVerificationRoutes.get("", use: verifyEmail)
            }
            
            auth.group("reset-password") { resetPasswordRoutes in
                resetPasswordRoutes.post("", use: resetPassword)
                resetPasswordRoutes.get("verify", use: verifyResetPasswordToken)
            }
            auth.post("recover", use: recoverAccount)
            
            auth.post("accessToken", use: refreshAccessToken)
            
            // Authentication required
            auth.group(Payload.guardMiddleware()) { authenticated in
                authenticated.get("me", use: getCurrentUser)
            }
        }
        routes.group("auth") { auth in
            auth.get("sign-in", use: signIn)
            auth.post("login", use: signInAction)
            auth.get("sign-out", use: signOut)
            auth.get("register", use: add)
            auth.post("save", use: save)
        }
    }

    /// Display the sign in page.
    func signIn(req: Request) async throws -> Response {
        logger.info("Load SignIn")
        return req.templates.renderHtml(SignInTemplate(SignInContext(name: "")))
    }
    
    func signOut(req: Request) async throws -> Response {
        logger.info("SignOut")
        req.auth.logout(AuthenticatedUser.self)
        req.session.destroy()
        return req.redirect(to: "/")
    }
    
    func signInAction(req: Request) throws -> Future<Response> {
        logger.info("LogIn")
        req.auth.logout(AuthenticatedUser.self)
        try LoginRequest.validate(content: req)
        let credentials = try req.content.decode(LoginRequest.self)
        return UserCredentialsAuthenticator().authenticate(credentials: credentials, for: req)
            .map {
                if let user = req.auth.get(AuthenticatedUser.self) {
                    logger.info("User \(user) logged in (Session: \(req.session.id?.string ?? "")).")
                    return req.redirect(to: "/")
                } else {
                    req.session.destroy()
                    let signInContext = SignInContext(name: credentials.email, error: "Unable to find the user name and password combination.")
                    return req.templates.renderHtml(SignInTemplate(signInContext))
                }
            }
    }

    public func add(req: Request) -> Response {
        logger.info("Load Register")
        return req.templates.renderHtml(RegisterTemplate())
    }

    public func save(req: Request)  -> Future<Response> {
        logger.info("Save Registration")
        do {
            return try register(req)
                .map { status in
                    return req.redirect(to: "/auth/sign-in/")
                }
        } catch let error {
            logger.error("Register request save error: \(error.localizedDescription)")
            return req.eventLoop.makeFailedFuture(error.localizedDescription)
        }
    }

    // MARK: Controller for authentication
    
    /// POST /api/auth/register
    /// - Parameter request: See `Vapor.Request`.
    /// - throws:
    ///    Normally, no error is thrown in this function.
    /// - returns:
    ///    The `Future` that returns `Response`.
    func register(_ req: Request) throws -> Future<HTTPStatus> {
        logger.info("registerRequest.validate: \(req.content)")
        try UserDTO.validate(content: req)
        let registerRequest = try req.content.decode(UserDTO.self)
        logger.info("registerRequest.decode: \(registerRequest.email)")
        guard registerRequest.password == registerRequest.confirmPassword else {
            logger.error("Register request passwords don't match")
            throw AuthenticationError.passwordsDontMatch
        }
        return try useCase.register(req, registerRequest: registerRequest)
    }

    /// POST /api/auth/login
    /// - Parameter request: See `Vapor.Request`.
    /// - throws:
    ///    Normally, no error is thrown in this function.
    /// - returns:
    ///    The `Future` that returns `Response`.
    func login(_ req: Request) throws -> Future<LoginResponse> {
        try LoginRequest.validate(content: req)
        let loginRequest = try req.content.decode(LoginRequest.self)
        logger.info("loginRequest: \(loginRequest.email)")
        return useCase.login(req, loginRequest: loginRequest)
    }
    
    func logout(_ req: Request) throws -> Future<HTTPStatus> {
        if let user = req.auth.get(Payload.self) {
            req.auth.logout(Payload.self)
            logger.info("User \(user) logged out.")
            req.session.destroy()
            return req.eventLoop.makeSucceededFuture(.noContent)
        } else {
            req.session.destroy()
            return req.eventLoop.makeFailedFuture(AuthenticationError.userNotFound)
        }
    }
    
    /// POST /api/auth/email-verification
    ///
    /// Auth then search user.
    /// - Parameter request: See `Vapor.Request`.
    /// - throws:
    ///    Normally, no error is thrown in this function.
    /// - returns:
    ///    The `Future` that returns `Response`.
    func refreshAccessToken(_ req: Request) throws -> Future<AccessTokenResponse> {
        let accessTokenRequest = try req.content.decode(AccessTokenRequest.self)
        let hashedRefreshToken = SHA256.hash(data: accessTokenRequest.refreshToken.data(using: .utf8)!)
        logger.info("refreshAccessTokenRequest: \(hashedRefreshToken)")
        return try useCase.refreshAccessToken(req, hashedRefreshToken: hashedRefreshToken)
    }
    
    /// GET  /api/auth/me
    ///
    /// Auth then search user.
    /// - Parameter request: See `Vapor.Request`.
    /// - throws:
    ///    Normally, no error is thrown in this function.
    /// - returns:
    ///    The `Future` that returns `Response`.
    func getCurrentUser(_ req: Request) throws -> Future<UserDTO> {
        let payload = try req.auth.require(Payload.self)
        logger.info("getCurrentUserRequest: \(payload.email)")
        return useCase.getCurrentUser(req, payload: payload)
    }
    
    /// GET /api/auth/email-verification
    ///
    /// Auth then search user.
    /// - Parameter request: See `Vapor.Request`.
    /// - throws:
    ///    Normally, no error is thrown in this function.
    /// - returns:
    ///    The `Future` that returns `Response`.
    func verifyEmail(_ req: Request) throws -> Future<HTTPStatus> {
        let token = try req.query.get(String.self, at: "token")
        let hashedToken = SHA256.hash(token)
        logger.info("verifyEmailRequest: \(hashedToken)")
        return try useCase.verifyEmail(req, hashedToken: hashedToken)
    }
    
    /// POST /api/auth/reset-password
    ///
    /// Auth then search user.
    /// - Parameter request: See `Vapor.Request`.
    /// - throws:
    ///    Normally, no error is thrown in this function.
    /// - returns:
    ///    The `Future` that returns `Response`.
    func resetPassword(_ req: Request) throws -> Future<HTTPStatus> {
        let resetPasswordRequest = try req.content.decode(ResetPasswordRequest.self)
        logger.info("resetPasswordRequest: \(resetPasswordRequest.email)")
        return try useCase.resetPassword(req, resetPasswordRequest: resetPasswordRequest)
    }
    
    /// GET /api/auth/reset-password/verify
    ///
    /// Auth then search user.
    /// - Parameter request: See `Vapor.Request`.
    /// - throws:
    ///    Normally, no error is thrown in this function.
    /// - returns:
    ///    The `Future` that returns `Response`.
    func verifyResetPasswordToken(_ req: Request) throws -> Future<HTTPStatus> {
        let token = try req.query.get(String.self, at: "token")
        let hashedToken = SHA256.hash(token)
        logger.info("verifyResetPasswordRequest: \(hashedToken)")
        return try useCase.verifyResetPasswordToken(req, hashedToken: hashedToken)
    }
    
    /// POST /api/auth/recover
    ///
    /// Auth then search user.
    /// - Parameter request: See `Vapor.Request`.
    /// - throws:
    ///    Normally, no error is thrown in this function.
    /// - returns:
    ///    The `Future` that returns `Response`.
    func recoverAccount(_ req: Request) throws -> Future<HTTPStatus> {
        try RecoverAccountRequest.validate(content: req)
        let content = try req.content.decode(RecoverAccountRequest.self)
        guard content.password == content.confirmPassword else {
            throw AuthenticationError.passwordsDontMatch
        }
        let hashedToken = SHA256.hash(content.token)
        logger.info("recoverAccountRequest: \(hashedToken), \(content.password)")
        return try useCase.recoverAccount(req, contentPassword: content.password, hashedToken: hashedToken)
    }
    
    /// GET /api/auth/reset-password/verify
    ///
    /// Auth then search user.
    /// - Parameter request: See `Vapor.Request`.
    /// - throws:
    ///    Normally, no error is thrown in this function.
    /// - returns:
    ///    The `Future` that returns `Response`.
    func sendEmailVerification(_ req: Request) throws -> Future<HTTPStatus> {
        let content = try req.content.decode(SendEmailVerificationRequest.self)
        logger.info("sendEmailVerificationRequest: \(content.email)")
        return try useCase.sendEmailVerification(req, content: content)
    }
}
