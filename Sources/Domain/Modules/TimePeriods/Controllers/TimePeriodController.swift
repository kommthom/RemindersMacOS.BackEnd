//
//  TimePeriodController.swift
//  
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Vapor
import Fluent
import DTO

public struct TimePeriodController: RouteCollection {
    private let useCase = TimePeriodUseCase()
    private let logger = Logger(label: "reminders.backend.timePeriods")
    
    public func boot(routes: RoutesBuilder) throws {
        routes.grouped("api", "timePeriods").group(Payload.guardMiddleware()) { timePeriod in
            timePeriod.post("create", use: createTimePeriod)
            timePeriod.post("get", use: getTimePeriod)
            timePeriod.post("getall", use: getTimePeriods)
            timePeriod.post("update", use: updateTimePeriod)
            timePeriod.post("delete", use: deleteTimePeriod)
            timePeriod.post("getforselection", use: getTimePeriodsWithSelection)
            timePeriod.post("updateselection", use: updateTimePeriodSelection)
        }
        routes.grouped("timePeriods").grouped(UserSessionAuthenticator()).group(AuthenticatedUser.guardMiddleware()) { timePeriod in
            //show Html
            timePeriod.get("index", use: index)
            timePeriod.get("add", use: add)
            timePeriod.post("save", use: save)
            timePeriod.get("show", use: show)
            timePeriod.post("update", use: update)
            timePeriod.post("delete", use: delete)
        }
    }

    public func createTimePeriod(_ req: Request) -> Future<HTTPStatus> {
        do {
            try TimePeriodDTO.validate(content: req)
            let createTimePeriodRequest = try req.content.decode(TimePeriodDTO.self)
            return useCase.createTimePeriod(req, createTimePeriodRequest: createTimePeriodRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(TimePeriodControllerError.unableToCreateNewRecord)
        }
    }

    public func getTimePeriod(_ req: Request) -> Future<TimePeriodDTO> {
        do {
            let getTimePeriodRequest = try req.content.decode(UUIDRequest.self)
            return useCase.getTimePeriod(req, getTimePeriodRequest: getTimePeriodRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(TimePeriodControllerError.idParameterInvalid)
        }
    }

    public func getTimePeriods(_ req: Request) -> Future<TimePeriodsDTO> {
        return useCase.getTimePeriods(req)
    }

    public func updateTimePeriod(_ req: Request) -> Future<HTTPStatus> {
        do {
            try TimePeriodDTO.validate(content: req)
            let timePeriod = try req.content.decode(TimePeriodDTO.self)
            return useCase.updateTimePeriod(req, updateTimePeriodRequest: timePeriod)
        } catch {
            return req.eventLoop.makeFailedFuture(TimePeriodControllerError.unableToUpdateRecord)
        }
    }
    
    public func deleteTimePeriod(_ req: Request) -> Future<HTTPStatus> {
        do {
            let deleteTimePeriodRequest = try req.content.decode(UUIDRequest.self)
            return useCase.deleteTimePeriod(req, deleteTimePeriodRequest: deleteTimePeriodRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(TimePeriodControllerError.unableToDeleteRecord)
        }
    }
    
    public func getTimePeriodsWithSelection(_ req: Request) -> Future<TimePeriodSelectionsDTO> {
        do {
            let allWithSelectionRequest = try req.content.decode(UUIDRequest.self)
            return useCase.getTimePeriodsWithSelection(req, allWithSelectionRequest: allWithSelectionRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(TimePeriodControllerError.idParameterInvalid)
        }
    }
    
    public func updateTimePeriodSelection(_ req: Request) -> Future<HTTPStatus> {
        do {
            try TimePeriodSelectionsDTO.validate(content: req)
            let timePeriodSelectionsRequest = try req.content.decode(TimePeriodSelectionsDTO.self)
            return useCase.updateSelection(req, setSelectionRequest: timePeriodSelectionsRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(TimePeriodControllerError.invalidForm)
        }
    }
    
    public func index(req: Request) -> Future<Response> {
        return useCase.getTimePeriods(req)
            .map() { timePeriods in
                req.templates.renderHtml(TimePeriodIndexTemplate(timePeriods))
            }
    }

    public func show(req: Request) -> Future<Response> {
        do {
            let getTimePeriodRequest = try req.content.decode(UUIDRequest.self)
            return showTimePeriod(req, getTimePeriodRequest.id)
        } catch {
            return req.eventLoop.makeFailedFuture(TimePeriodControllerError.idParameterMissing)
        }
    }

    private func showTimePeriod(_ req: Request, _ timePeriodId: UUID) -> Future<Response> {
        return getTimePeriod(req)
            .map() { timePeriod in
                req.templates.renderHtml(TimePeriodShowTemplate(timePeriod))
            }
    }
    
    public func add(req: Request) -> Response {
        return req.templates.renderHtml(TimePeriodAddTemplate())
    }

    public func save(req: Request)  -> Future<Response> {
        return createTimePeriod(req)
            .map { status in
                return req.redirect(to: "/timeperiods/index")
            }
    }

    public func update(req: Request) -> Future<Response> {
        return updateTimePeriod(req)
            .map { status in
                return req.redirect(to: "/timeperiods/index")
            }
    }

    public func delete(req: Request) -> Future<Response> {
        return deleteTimePeriod(req)
            .map { status in
                return req.redirect(to: "/timeperiods/index")
            }
    }
}

