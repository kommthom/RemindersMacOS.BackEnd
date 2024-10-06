//
//  AuthUseCaseProtocol.swift
//
//
//  Created by Thomas Benninghaus on 27.12.23.
//

import Vapor
import DTO

public protocol AuthUseCaseProtocol: UseCaseProtocol {
    func login(_ req: Request, loginRequest: LoginRequest) -> Future<LoginResponse> 
    func register(_ req: Request, registerRequest: UserDTO) throws -> Future<HTTPStatus>
    func refreshAccessToken(_ req: Request, hashedRefreshToken: String) throws -> Future<AccessTokenResponse>
    func getCurrentUser(_ req: Request, payload: Payload) -> Future<UserDTO>
    func verifyEmail(_ req: Request, hashedToken: String) throws -> Future<HTTPStatus>
    func resetPassword(_ req: Request, resetPasswordRequest: ResetPasswordRequest) throws -> Future<HTTPStatus>
    func verifyResetPasswordToken(_ req: Request, hashedToken: String) throws -> Future<HTTPStatus>
    func recoverAccount(_ req: Request, contentPassword: String, hashedToken: String) throws -> Future<HTTPStatus>
    func sendEmailVerification(_ req: Request, content: SendEmailVerificationRequest) throws -> Future<HTTPStatus>
}
