//
//  UserUseCaseProtocol.swift
//
//
//  Created by Thomas Benninghaus on 27.12.23.
//

import Vapor
import DTO

public protocol UserUseCaseProtocol: UseCaseProtocol {
    func createUser(_ req: Request, createUserRequest: UserDTO) throws -> Future<HTTPStatus>
    func getUser(_ req: Request, getUserRequest: UUIDRequest) -> Future<UserDTO>
    func getUsers(_ req: Request) -> Future<UsersDTO>
    func updateUser(_ req: Request, payload: Payload) -> Future<HTTPStatus>
    func deleteUser(_ req: Request, deleteUserRequest: UUIDRequest) -> Future<HTTPStatus>
}
