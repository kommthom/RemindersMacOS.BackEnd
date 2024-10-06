//
//  AuthUseCase.swift
//  
//
//  Created by Thomas Benninghaus on 21.12.23.
//

import Vapor
import Fluent
import DTO

/// Use cases for Authentication
public struct AuthUseCase: AuthUseCaseProtocol {
    private let logger = Logger(label: "reminders.backend.authuc")

    public init() { }
    
    public func login(_ req: Request, loginRequest: LoginRequest) -> Future<LoginResponse> {
        return req.users
            .find(email: loginRequest.email)
            .unwrap(or: AuthenticationError.invalidEmailOrPassword)
            .guard({ $0.isEmailVerified }, else: AuthenticationError.emailIsNotVerified)
            .flatMap { user -> Future<UserModel> in
                logger.info("login user:\(user.email)|\(user.passwordHash)")
                return req.password
                    .async
                    .verify(loginRequest.password, created: user.passwordHash)
                    .guard({ $0 == true }, else: AuthenticationError.invalidEmailOrPassword)
                    .transform(to: user)
        }
        .flatMap { user -> Future<UserModel> in
            do {
                let _ = try req.refreshTokens.delete(for: user.requireID()) //.transform(to: user)
                logger.info("Delete token for user: \(user.email)")
                return req.eventLoop.makeSucceededFuture(user)
            } catch {
                return req.eventLoop.makeFailedFuture(error)
            }
        }
        .flatMap { user in
            do {
                let token = req.random.generate(bits: 256)
                logger.info("Create token for user: \(user.email): \(token)")
                let refreshToken = try RefreshToken(token: SHA256.hash(token), userID: user.requireID())
                logger.info("RefreshToken for user: \(user.email) token: \(token) refreshToken: \(refreshToken.token)")
                return req
                    .refreshTokens
                    .create(refreshToken)
                    .flatMapThrowing {
                        logger.info("Return user: \(user.email) token: \(token)")
                        return try LoginResponse(
                            user: UserDTO(model: user, localization: {
                                req.userLocalization.localize($0, interpolations: nil, req: req)
                            }),
                            accessToken: req.jwt.sign(Payload(with: user, localization: {
                                req.userLocalization.localize($0, interpolations: nil, req: req)
                            } )),
                            refreshToken: token
                        )
                }
            } catch {
                return req.eventLoop.makeFailedFuture(error)
            }
        }
    }

    public func register(_ req: Request, registerRequest: UserDTO) throws -> Future<HTTPStatus> {
        return req.password
            .async
            .hash(registerRequest.password)
            .flatMapThrowing { try UserModel(from: registerRequest, hash: $0) }
            .flatMap { user in
                return req.users
                    .create(user)
                    .flatMap { req.emailVerifier.verify(for: user) }
            }
            .transform(to: .created)
    }

    public func refreshAccessToken(_ req: Request, hashedRefreshToken: String) throws -> Future<AccessTokenResponse> {
        return req.refreshTokens
            .find(token: hashedRefreshToken)
            .unwrap(or: AuthenticationError.refreshTokenOrUserNotFound)
            .flatMap { req.refreshTokens.delete($0).transform(to: $0) }
            .guard({ $0.expiresAt > Date() }, else: AuthenticationError.refreshTokenHasExpired)
            .flatMap { req.users.find(id: $0.$user.id) }
            .unwrap(or: AuthenticationError.refreshTokenOrUserNotFound)
            .flatMap { user in
                do {
                    let token = req.random.generate(bits: 256)
                    let refreshToken = try RefreshToken(token: SHA256.hash(token), userID: user.requireID())
                    
                    let payload = try Payload(with: user) {
                        req.userLocalization.localize($0, interpolations: nil, req: req)
                    }
                    let accessToken = try req.jwt.sign(payload)
                    
                    return req.refreshTokens
                        .create(refreshToken)
                        .transform(to: (token, accessToken))
                } catch {
                    return req.eventLoop.makeFailedFuture(error)
                }
        }
        .map { AccessTokenResponse(refreshToken: $0, accessToken: $1) }
    }
    
    
    public func getCurrentUser(_ req: Request, payload: Payload) -> Future<UserDTO> {
        return req.users
            .find(id: payload.userID)
            .unwrap(or: AuthenticationError.userNotFound)
            .map { UserDTO(model: $0, localization: {
                req.userLocalization.localize($0, interpolations: nil, req: req)
            }) }
    }
    
    public func verifyEmail(_ req: Request, hashedToken: String) throws -> Future<HTTPStatus> {
        return req.emailTokens
            .find(token: hashedToken)
            .unwrap(or: AuthenticationError.emailTokenNotFound)
            .flatMap { req.emailTokens.delete($0).transform(to: $0) }
            .guard({ $0.expiresAt > Date() },
                   else: AuthenticationError.emailTokenHasExpired)
            .flatMap {
                req.users.set(\.$isEmailVerified, to: true, for: $0.$user.id)
        }
        .transform(to: .ok)
    }
    
    public func resetPassword(_ req: Request, resetPasswordRequest: ResetPasswordRequest) throws -> Future<HTTPStatus> {
       return req.users
           .find(email: resetPasswordRequest.email)
           .flatMap {
               if let user = $0 {
                   return req.passwordResetter
                       .reset(for: user)
                       .transform(to: HTTPStatus.noContent)
               } else {
                   return req.eventLoop.makeSucceededFuture(.noContent)
               }
       }
    }
    
    public func verifyResetPasswordToken(_ req: Request, hashedToken: String) throws -> Future<HTTPStatus> {
        return req.passwordTokens
            .find(token: hashedToken)
            .unwrap(or: AuthenticationError.invalidPasswordToken)
            .flatMap { passwordToken in
                guard passwordToken.expiresAt > Date() else {
                    return req.passwordTokens
                        .delete(passwordToken)
                        .transform(to: req.eventLoop
                            .makeFailedFuture(AuthenticationError.passwordTokenHasExpired)
                    )
                }
                return req.eventLoop.makeSucceededFuture(.noContent)
        }
    }
    
    public func recoverAccount(_ req: Request, contentPassword: String, hashedToken: String) throws -> Future<HTTPStatus> {
        return req.passwordTokens
            .find(token: hashedToken)
            .unwrap(or: AuthenticationError.invalidPasswordToken)
            .flatMap { passwordToken -> Future<Void> in
                guard passwordToken.expiresAt > Date() else {
                    return req.passwordTokens
                        .delete(passwordToken)
                        .transform(to: req.eventLoop
                            .makeFailedFuture(AuthenticationError.passwordTokenHasExpired)
                    )
                }
                return req.password
                    .async
                    .hash(contentPassword)
                    .flatMap { digest in
                        req.users.set(\.$passwordHash, to: digest, for: passwordToken.$user.id)
                }
                .flatMap { req.passwordTokens.delete(for: passwordToken.$user.id) }
        }
        .transform(to: .noContent)
    }
    
    public func sendEmailVerification(_ req: Request, content: SendEmailVerificationRequest) throws -> Future<HTTPStatus> {
        return req.users
            .find(email: content.email)
            .flatMap {
                guard let user = $0, !user.isEmailVerified else {
                    return req.eventLoop.makeSucceededFuture(HTTPStatus.noContent)
                }
                return req.emailVerifier
                    .verify(for: user)
                    .transform(to: HTTPStatus.noContent)
        }
    }
}
