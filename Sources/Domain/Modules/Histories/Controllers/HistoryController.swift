//
//  HistoryController.swift
//  
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Vapor
import Fluent
import DTO

public struct HistoryController: RouteCollection {
    private let useCase = HistoryUseCase()
    private let logger = Logger(label: "reminders.backend.histories")
    
    public func boot(routes: RoutesBuilder) throws {
        routes.grouped("api", "histories").group(Payload.guardMiddleware()) { history in
            history.post("create", use: createHistory)
            history.post("get", use: getHistory)
            history.post("getall", use: getHistories)
            history.post("update", use: updateHistory)
            history.post("delete", use: deleteHistory)
        }
        routes.grouped("histories").grouped(UserSessionAuthenticator()).group(AuthenticatedUser.guardMiddleware()) { history in
            //show Html
            history.get("index", use: index)
            history.get("add", use: add)
            history.post("save", use: save)
            history.get("show", use: show)
            history.post("update", use: update)
            history.post("delete", use: delete)
        }
    }

    public func createHistory(_ req: Request) -> Future<HTTPStatus> {
        do {
            let historyRequest = try req.content.decode(HistoryDTO.self)
            return useCase.createHistory(req, createHistoryRequest: historyRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(HistoryControllerError.unableToCreateNewRecord)
        }
    }

    public func getHistory(_ req: Request) -> Future<HistoryDTO> {
        do {
            let getHistoryRequest = try req.content.decode(UUIDRequest.self)
            return useCase.getHistory(req, getHistoryRequest: getHistoryRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(HistoryControllerError.idParameterInvalid)
        }
    }

    public func getHistories(_ req: Request) -> Future<HistoriesDTO> {
        do {
            let getHistoriesRequest = try req.content.decode(UUIDRequest.self)
            return useCase.getHistories(req, getHistoriesRequest: getHistoriesRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(HistoryControllerError.idParameterInvalid)
        }
    }
    
    public func updateHistory(_ req: Request) -> Future<HTTPStatus> {
        do {
            let history = try req.content.decode(HistoryDTO.self)
            return useCase.updateHistory(req, updateHistoryRequest: history)
        } catch {
            return req.eventLoop.makeFailedFuture(HistoryControllerError.unableToUpdateRecord)
        }
    }
    
    public func deleteHistory(_ req: Request) -> Future<HTTPStatus> {
        do {
            let deleteHistoryRequest = try req.content.decode(UUIDRequest.self)
            return useCase.deleteHistory(req, deleteHistoryRequest: deleteHistoryRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(HistoryControllerError.unableToDeleteRecord)
        }
    }
    
    public func index(req: Request) -> Future<Response> {
        return getHistories(req)
            .map() { histories in
                req.templates.renderHtml(HistoryIndexTemplate(histories))
            }
    }

    public func show(req: Request) -> Future<Response> {
        do {
            let getHistoryRequest = try req.content.decode(UUIDRequest.self)
            return showHistory(req, getHistoryRequest.id)
        } catch {
            return req.eventLoop.makeFailedFuture(HistoryControllerError.idParameterMissing)
        }
    }

    private func showHistory(_ req: Request, _ historyId: UUID) -> Future<Response> {
        return getHistory(req)
            .map() { history in
                req.templates.renderHtml(HistoryShowTemplate(history))
            }
    }
    
    public func add(req: Request) -> Response {
        return req.templates.renderHtml(HistoryAddTemplate())
    }

    public func save(req: Request)  -> Future<Response> {
        return createHistory(req)
            .map { status in
                return req.redirect(to: "/histories/index")
            }
    }

    public func update(req: Request) -> Future<Response> {
        return updateHistory(req)
            .map { status in
                return req.redirect(to: "/histories/index")
            }
    }

    public func delete(req: Request) -> Future<Response> {
        return deleteHistory(req)
            .map { status in
                return req.redirect(to: "/histories/index")
            }
    }
}
