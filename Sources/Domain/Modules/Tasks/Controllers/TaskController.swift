//
//  TaskController.swift
//
//
//  Created by Thomas Benninghaus on 24.12.23.
//

import Vapor
import Fluent
import DTO

struct TaskController: RouteCollection {
    private let useCase = TaskUseCase()
    
    func boot(routes: RoutesBuilder) throws {
        routes.grouped("api", "tasks").group(Payload.guardMiddleware()) { task in
            task.post("create", use: createTask)
            task.post("get", use: getTask)
            task.post("getall", use: getTasks)
            task.post("update", use: updateTask)
            task.post("complete", use: completeTask)
            task.post("delete", use: deleteTask)
            task.post("gettoday", use: getTasksToday)
            task.post("getsoon", use: getTasksSoon)
            task.post("getfortag", use: getTasksForTag)
            task.post("getfortags", use: getTasksForTags)
        }
        routes.grouped("tasks").grouped(UserSessionAuthenticator()).group(AuthenticatedUser.guardMiddleware()) { task in
            //show Html
            task.get("index", use: index)
            task.get("add", use: add)
            task.post("save", use: save)
            task.get("show", use: show)
            task.post("update", use: update)
            task.post("delete", use: delete)
        }
    }

    func createTask(_ req: Request) throws -> Future<HTTPStatus> {
        try TaskDTO.validate(content: req)
        let createTaskRequest = try req.content.decode(TaskDTO.self)
        return useCase.createTask(req, createTaskRequest: createTaskRequest)
    }
    
    func getTask(_ req: Request) throws -> Future<TaskDTO> {
        let getTaskRequest = try req.content.decode(UUIDRequest.self)
        return useCase.getTask(req, getTaskRequest: getTaskRequest)
    }
    
    func getTasks(_ req: Request) throws -> Future<TasksDTO> {
        let getTasksRequest = try req.content.decode(UUIDRequest.self)
        return useCase.getTasks(req, getTasksRequest: getTasksRequest)
    }

    func updateTask(_ req: Request) throws -> Future<HTTPStatus> {
        try TaskDTO.validate(content: req)
        let updateTaskRequest = try req.content.decode(TaskDTO.self)
        return useCase.updateTask(req, updateTaskRequest: updateTaskRequest)
    }
    
    func completeTask(_ req: Request) throws -> Future<HTTPStatus> {
        let setTaskCompletedRequest = try req.content.decode(UUIDRequest.self)
        return useCase.setCompleted(req, setTaskCompletedRequest: setTaskCompletedRequest)
    }
    
    func deleteTask(_ req: Request) throws -> Future<HTTPStatus> {
        let deleteTaskRequest = try req.content.decode(UUIDRequest.self)
        return useCase.deleteTask(req, deleteTaskRequest: deleteTaskRequest)
    }
    
    func getTasksToday(_ req: Request) -> Future<TaskGroupsDTO> {
        return useCase.getTasksForToday(req)
    }
    
    func getTasksSoon(_ req: Request) -> Future<TaskGroupsDTO> {
        return useCase.getTasksSoon(req)
    }
    
    func getTasksForTag(_ req: Request) throws -> Future<TaskGroupsDTO> {
        let getTasksForTagRequest = try req.content.decode(UUIDRequest.self)
        return useCase.getTasksForTags(req, getTasksForTagsRequest: UUIDArrayRequest(ids: [getTasksForTagRequest.id]))
    }
    
    func getTasksForTags(_ req: Request) throws -> Future<TaskGroupsDTO> {
        let getTasksForTagsRequest = try req.content.decode(UUIDArrayRequest.self)
        return useCase.getTasksForTags(req, getTasksForTagsRequest: getTasksForTagsRequest)
    }
    
    public func index(req: Request) -> Future<Response> {
        do {
            let getTaskRequest = try req.content.decode(UUIDRequest.self)
            return useCase.getTasks(req, getTasksRequest: getTaskRequest)
                .map() { projects in
                    req.templates.renderHtml(TaskIndexTemplate(projects))
                }
        } catch {
            return req.eventLoop.makeFailedFuture(TaskControllerError.idParameterMissing)
        }
    }

    public func show(req: Request) throws -> Future<Response> {
        do {
            let getTaskRequest = try req.content.decode(UUIDRequest.self)
            return try showTask(req, getTaskRequest.id)
        } catch {
            return req.eventLoop.makeFailedFuture(TaskControllerError.idParameterMissing)
        }
    }

    private func showTask(_ req: Request, _ taskId: UUID) throws -> Future<Response> {
        return try getTask(req)
            .map { task in
                req.templates.renderHtml(TaskShowTemplate(task))
            }
    }
    
    public func add(req: Request) -> Response {
        return req.templates.renderHtml(TaskAddTemplate())
    }

    public func save(req: Request)  -> Future<Response> {
        do {
            return try createTask(req)
                .map { status in
                    return req.redirect(to: "/tasks/index")
                }
        } catch {
            return req.eventLoop.makeFailedFuture(TaskControllerError.unableToCreateNewRecord)
        }
    }

    public func update(req: Request) -> Future<Response> {
        do {
            return try updateTask(req)
                .map { status in
                    return req.redirect(to: "/tasks/index")
                }
        } catch {
            return req.eventLoop.makeFailedFuture(TaskControllerError.unableToUpdateRecord)
        }
    }

    public func delete(req: Request) -> Future<Response> {
        do {
            return try deleteTask(req)
                .map { status in
                    return req.redirect(to: "/tasks/index")
                }
        } catch {
            return req.eventLoop.makeFailedFuture(TaskControllerError.unableToDeleteRecord)
        }
    }
}
