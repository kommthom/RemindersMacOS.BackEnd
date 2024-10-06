//
//  RepetitionController.swift
//  
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Vapor
import Fluent
import DTO

public struct RepetitionController: RouteCollection {
    private let useCase = RepetitionUseCase()
    private let logger = Logger(label: "reminders.backend.repetitions")
    
    public func boot(routes: RoutesBuilder) throws {
        routes.grouped("api", "repetitions").group(Payload.guardMiddleware()) { repetition in
            repetition.post("create", use: createRepetition)
            repetition.post("get", use: getRepetition)
            repetition.post("getall", use: getRepetitions)
            repetition.post("update", use: updateRepetition)
            repetition.post("delete", use: deleteRepetition)
        }
        routes.grouped("repetitions").grouped(UserSessionAuthenticator()).group(AuthenticatedUser.guardMiddleware()) { repetition in
            //show Html
            repetition.get("index", use: index)
            repetition.get("add", use: add)
            repetition.post("save", use: save)
            repetition.get("show", use: show)
            repetition.post("update", use: update)
            repetition.post("delete", use: delete)
        }
    }

    public func createRepetition(_ req: Request) -> Future<HTTPStatus> {
        do {
            try RepetitionDTO.validate(content: req)
            let repetitionRequest = try req.content.decode(RepetitionDTO.self)
            return useCase.createRepetition(req, createRepetitionRequest: repetitionRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(RepetitionControllerError.unableToCreateNewRecord)
        }
    }

    public func getRepetition(_ req: Request) -> Future<RepetitionDTO> {
        do {
            let getRepetitionRequest = try req.content.decode(UUIDRequest.self)
            return useCase.getRepetition(req, getRepetitionRequest: getRepetitionRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(RepetitionControllerError.idParameterInvalid)
        }
    }

    public func getRepetitions(_ req: Request) -> Future<RepetitionsDTO> {
        do {
            let getRepetitionsRequest = try req.content.decode(UUIDRequest.self)
            return useCase.getRepetitions(req, getRepetitionsRequest: getRepetitionsRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(RepetitionControllerError.idParameterInvalid)
        }
    }
    
    public func updateRepetition(_ req: Request) -> Future<HTTPStatus> {
        do {
            try RepetitionDTO.validate(content: req)
            let repetition = try req.content.decode(RepetitionDTO.self)
            return useCase.updateRepetition(req, updateRepetitionRequest: repetition)
        } catch {
            return req.eventLoop.makeFailedFuture(RepetitionControllerError.unableToUpdateRecord)
        }
    }
    
    public func deleteRepetition(_ req: Request) -> Future<HTTPStatus> {
        do {
            let deleteRepetitionRequest = try req.content.decode(UUIDRequest.self)
            return useCase.deleteRepetition(req, deleteRepetitionRequest: deleteRepetitionRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(RepetitionControllerError.unableToDeleteRecord)
        }
    }
    
    public func index(req: Request) -> Future<Response> {
        return getRepetitions(req)
            .map() { repetitions in
                req.templates.renderHtml(RepetitionIndexTemplate(repetitions))
            }
    }

    public func show(req: Request) -> Future<Response> {
        do {
            let getRepetitionRequest = try req.content.decode(UUIDRequest.self)
            return showRepetition(req, getRepetitionRequest.id)
        } catch {
            return req.eventLoop.makeFailedFuture(RepetitionControllerError.idParameterMissing)
        }
    }

    private func showRepetition(_ req: Request, _ repetitionId: UUID) -> Future<Response> {
        return getRepetition(req)
            .map() { repetition in
                req.templates.renderHtml(RepetitionShowTemplate(repetition))
            }
    }
    
    public func add(req: Request) -> Response {
        return req.templates.renderHtml(RepetitionAddTemplate())
    }

    public func save(req: Request)  -> Future<Response> {
        return createRepetition(req)
            .map { status in
                return req.redirect(to: "/repetitions/index")
            }
    }

    public func update(req: Request) -> Future<Response> {
        return updateRepetition(req)
            .map { status in
                return req.redirect(to: "/repetitions/index")
            }
    }

    public func delete(req: Request) -> Future<Response> {
        return deleteRepetition(req)
            .map { status in
                return req.redirect(to: "/repetitions/index")
            }
    }
}
