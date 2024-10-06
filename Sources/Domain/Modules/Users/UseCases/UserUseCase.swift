//
//  UserUseCase.swift
//
//
//  Created by Thomas Benninghaus on 27.12.23.
//

import Vapor
import Fluent
import DTO

public struct UserUseCase: UserUseCaseProtocol {

    public init() {}
    
    public func createUser(_ req: Request, createUserRequest: UserDTO) -> Future<HTTPStatus> {
        return req.password
            .async
            .hash(createUserRequest.password)
            .map { hash in
                UserModel(
                    id: createUserRequest.id,
                    fullName: createUserRequest.fullName,
                    email: createUserRequest.email,
                    passwordHash: hash,
                    isAdmin: createUserRequest.isAdmin,
                    isEmailVerified: createUserRequest.isEmailVerified,
                    imageURL: createUserRequest.imageURL,
                    localeId: createUserRequest.locale.id!,
                    locationId: createUserRequest.location.id!
                ) }
            .flatMap { user in
                req.users
                    .create(user)
                    .flatMap { req.emailVerifier.verify(for: user) }
        }
        .transform(to: .created)
    }

    public func getUser(_ req: Request, getUserRequest: UUIDRequest) -> Future<UserDTO> {
        return req.users
            .find(id: getUserRequest.id)
            .unwrap(or: AuthenticationError.emailTokenNotFound)
            .map { UserDTO(model: $0, localization: {
                req.userLocalization.localize($0, interpolations: nil, req: req)
            }) }
    }
    
    public func getUsers(_ req: Request) -> Future<UsersDTO> {
        return req.users
            .all()
            .map { users in
                return UsersDTO(many: users, localization: {
                    req.userLocalization.localize($0, interpolations: nil, req: req)
                })
            }
    }
    
    public func updateUser(_ req: Request, payload: Payload) -> Future<HTTPStatus> {
        return req.users
            .set(UserModel(from: payload))
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }

    public func deleteUser(_ req: Request, deleteUserRequest: UUIDRequest) -> Future<HTTPStatus> {
        return req.users
            .delete(id: deleteUserRequest.id, force: false)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }
}
