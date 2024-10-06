//
//  ProjectController.swift
//
//
//  Created by Thomas Benninghaus on 24.12.23.
//

import Vapor
import Fluent
import DTO

/// Controller For User processing
struct ProjectController: RouteCollection {
    private let useCase = ProjectUseCase()
    
    func boot(routes: RoutesBuilder) throws {
        routes.grouped("api", "projects").group(Payload.guardMiddleware()) { project in
            project.post("create", use: createProject)
            project.post("get", use: getProject)
            project.post("getarchive", use: getArchive)
            project.post("getinbox", use: getInbox)
            project.post("getall", use: getProjects)
            project.post("update", use: updateProject)
            project.post("delete", use: deleteProject)

        }
        routes.grouped("projects").group(AuthenticatedUser.guardMiddleware()) { project in
            //show Html
            project.get("index", use: index)
            project.get("add", use: add)
            project.post("save", use: save)
            project.get("show", use: show)
            project.post("update", use: update)
            project.post("delete", use: delete)
            //project.get("/projects/create", use: createProjectDemo)
        }
    }

    public func createProject(_ req: Request) -> Future<HTTPStatus> {
        do {
            try ProjectDTO.validate(content: req)
            let createProjectRequest = try req.content.decode(ProjectDTO.self)
            return useCase.createProject(req, createProjectRequest: createProjectRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(ProjectControllerError.unableToCreateNewRecord)
        }
    }

    public func getProject(_ req: Request) -> Future<ProjectDTO> {
        do {
            let getProjectRequest = try req.content.decode(UUIDRequest.self)
            return useCase.getProject(req, getProjectRequest: getProjectRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(ProjectControllerError.idParameterInvalid)
        }
    }

    public func getArchive(_ req: Request) -> Future<ProjectDTO> {
        return useCase.getArchive(req)
    }
    
    public func getInbox(_ req: Request) -> Future<ProjectDTO> {
        return useCase.getInbox(req)
    }
    
    public func getProjects(_ req: Request) -> Future<ProjectsDTO> {
        return useCase.getProjects(req)
    }

    public func updateProject(_ req: Request) -> Future<HTTPStatus> {
        do {
            try ProjectDTO.validate(content: req)
            let project = try req.content.decode(ProjectDTO.self)
            return useCase.updateProject(req, updateProjectRequest: project)
        } catch {
            return req.eventLoop.makeFailedFuture(ProjectControllerError.unableToUpdateRecord)
        }
    }
    
    public func deleteProject(_ req: Request) -> Future<HTTPStatus> {
        do {
            let deleteProjectRequest = try req.content.decode(UUIDRequest.self)
            return useCase.deleteProject(req, deleteProjectRequest: deleteProjectRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(ProjectControllerError.unableToDeleteRecord)
        }
    }
    /*
    public func createProjectDemo(_ req: Request) -> Future<Response> {
           return useCase.createProjectDemo(req)
               .map { status in
                   return req.redirect(to: "/projects/index")
               }
    }
    */
    public func index(req: Request) -> Future<Response> {
        return useCase.getProjects(req)
            .map() { projects in
                req.templates.renderHtml(ProjectIndexTemplate(projects))
            }
    }

    public func show(req: Request) -> Future<Response> {
        do {
            let getProjectRequest = try req.content.decode(UUIDRequest.self)
            return showProject(req, getProjectRequest.id)
        } catch {
            return req.eventLoop.makeFailedFuture(ProjectControllerError.idParameterMissing)
        }
    }

    private func showProject(_ req: Request, _ projectId: UUID) -> Future<Response> {
        return getProject(req)
            .map() { project in
                req.templates.renderHtml(ProjectShowTemplate(project))
            }
    }
    
    public func add(req: Request) -> Response {
        return req.templates.renderHtml(ProjectAddTemplate())
    }

    public func save(req: Request)  -> Future<Response> {
        return createProject(req)
            .map { status in
                return req.redirect(to: "/projects/index")
            }
    }

    public func update(req: Request) -> Future<Response> {
        return updateProject(req)
            .map { status in
                return req.redirect(to: "/projects/index")
            }
    }

    public func delete(req: Request) -> Future<Response> {
        return deleteProject(req)
            .map { status in
                return req.redirect(to: "/projects/index")
            }
    }
}
