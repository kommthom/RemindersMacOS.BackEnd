//
//  UserController.swift
//
//
//  Created by Thomas Benninghaus on 20.12.23.
//

import Vapor
import Fluent
import DTO

/// Controller For User processing
struct UserController: RouteCollection {
    
    // MARK: Properties
    
    /// The use case for authentication.
    ///
    /// See `UserUseCase`.
    private let useCase = UserUseCase()
    
    func boot(routes: RoutesBuilder) throws {
        routes.grouped("api").grouped("users").group(EnsureAdminUserMiddleware()) { user in
            user.post("create", use: createUser)
            user.post("get", use: getUser)
            user.post("getall", use: getUsers)
            user.post("update", use: updateUser)
            user.post("delete", use: deleteUser)
        }
        routes.grouped("users").group(EnsureAdminUserMiddleware()) { user in
            //show Html
            user.get("index", use: index)
            user.get("add", use: add)
            user.post("save", use: save)
            user.get("show", use: show)
            user.post("update", use: update)
            user.post("delete", use: delete)
        }
    }
    
    // MARK: Controller for users
    
    /// POST /api/tasks/create
    /// - Parameter request: See `Vapor.Request`.
    /// - throws:
    ///    Normally, no error is thrown in this function.
    /// - returns:
    ///    The `Future` that returns `Response`.
    public func createUser(_ req: Request) -> Future<HTTPStatus> {
        do {
            try UserDTO.validate(content: req)
            let createUserRequest = try req.content.decode(UserDTO.self)
            return useCase.createUser(req, createUserRequest: createUserRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(UserControllerError.unableToCreateNewRecord)
        }
    }
    
    /// POST /api/tasks/get
    /// - Parameter request: See `Vapor.Request`.
    /// - throws:
    ///    Normally, no error is thrown in this function.
    /// - returns:
    ///    The `Future` that returns `Response`.
    func getUser(_ req: Request) -> Future<UserDTO> {
        do {
            let getUserRequest = try req.content.decode(UUIDRequest.self)
            return useCase.getUser(req, getUserRequest: getUserRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(UserControllerError.idParameterInvalid)
        }
    }
    
    /// POST /api/tasks/getall
    /// - Parameter request: See `Vapor.Request`.
    /// - throws:
    ///    Normally, no error is thrown in this function.
    /// - returns:
    ///    The `Future` that returns `Response`.
    func getUsers(_ req: Request) -> Future<UsersDTO> {
        return useCase.getUsers(req)
    }
    
    /// POST /api/tasks/create
    /// - Parameter request: See `Vapor.Request`.
    /// - throws:
    ///    Normally, no error is thrown in this function.
    /// - returns:
    ///    The `Future` that returns `Response`.
    func updateUser(_ req: Request) -> Future<HTTPStatus> {
        do {
            try Payload.validate(content: req)
            let payload = try req.content.decode(Payload.self)
            return useCase.updateUser(req, payload: payload)
        } catch {
            return req.eventLoop.makeFailedFuture(UserControllerError.unableToUpdateRecord)
        }
    }
    
    /// POST /api/tasks/create
    /// - Parameter request: See `Vapor.Request`.
    /// - throws:
    ///    Normally, no error is thrown in this function.
    /// - returns:
    ///    The `Future` that returns `Response`.
    func deleteUser(_ req: Request) -> Future<HTTPStatus> {
        do {
            let deleteUserRequest = try req.content.decode(UUIDRequest.self)
            return useCase.deleteUser(req, deleteUserRequest: deleteUserRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(UserControllerError.unableToDeleteRecord)
        }
    }
    
    public func index(req: Request) -> Future<Response> {
        return useCase.getUsers(req)
            .map() { users in
                req.templates.renderHtml(UserIndexTemplate(users))
            }
    }

    public func show(req: Request) -> Future<Response> {
        do {
            let getUserIdString = try req.query.decode(IdRequest.self)
            return useCase.getUser(req, getUserRequest: UUIDRequest(from: getUserIdString))
                .map() { user in
                    req.templates.renderHtml(UserShowTemplate(user))
                }
        } catch {
            return req.eventLoop.makeFailedFuture(UserControllerError.idParameterMissing)
        }
    }
    
    public func add(req: Request) -> Response {
        return req.templates.renderHtml(UserAddTemplate())
    }

    public func save(req: Request)  -> Future<Response> {
        return createUser(req)
            .map { status in
                return req.redirect(to: "/users/index")
            }
    }

    public func update(req: Request) -> Future<Response> {
        return updateUser(req)
            .map { status in
                return req.redirect(to: "/users/index")
            }
    }

    public func delete(req: Request) -> Future<Response> {
        return deleteUser(req)
            .map { status in
                return req.redirect(to: "/users/index")
            }
    }
}
