//
//  ProjectUseCase.swift
//
//
//  Created by Thomas Benninghaus on 24.12.23.
//

import Vapor
import Fluent
import Resources
import DTO

public struct ProjectUseCase: ProjectUseCaseProtocol {
    public init() {}
    
    public func getAuthenticatedUser(_ req: Request) throws -> AuthenticatedUser? {
        if let authenticatedUser = req.auth.get(AuthenticatedUser.self) {
            return authenticatedUser
        } else {
            throw AuthenticationError.userNotFound
        }
    }
    
    private func translateProject(localization: LocalizationProtocol, locale: LocaleIdentifier, project: ProjectModel) -> ProjectModel {
        let description = localization.localize(project.name, locale: locale.language.code, interpolations: nil)
        if !description.isEmpty {
            let newProject = project
            newProject.name = description
            return newProject
        } else {
            return project
        }
    }
    
    public func createProject(_ req: Request, createProjectRequest: ProjectDTO) -> Future<HTTPStatus> {
        do {
            let userId = try (getAuthenticatedUser(req)?.id)!
            
            return req.projects
                .create(ProjectModel(model: createProjectRequest, userId: userId))
                .flatMap { //project
                    return createProjectRequest.items
                        .compactMap { taskDTO in //tasks
                            return TaskUseCase()
                                .createTask(req, createTaskRequest: taskDTO)
                        } //tasks
                        .flatten(on: req.eventLoop)
                } //project
                .transform(to: .created)
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }

    public func getProject(_ req: Request, getProjectRequest: UUIDRequest) -> Future<ProjectDTO> {
        return req.projects
            .find(id: getProjectRequest.id)
            .unwrap(or: ProjectControllerError.missingProject)
            .map { ProjectDTO(model: $0) }
    }
    
    public func getInbox(_ req: Request) -> Future<ProjectDTO> {
        do {
            let localization = req.userLocalization
            let authenticatedUser = try getAuthenticatedUser(req)
            return req.projects
                .find(userId: authenticatedUser!.id, name: Constants.projectsRootName)
                .unwrap(or: ProjectControllerError.missingProject)
                .map { project in
                    ProjectDTO(model: translateProject(localization: localization, locale: authenticatedUser!.locale, project: project))
                }
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func getArchive(_ req: Request) -> Future<ProjectDTO> {
        do {
            let localization = req.userLocalization
            let authenticatedUser = try getAuthenticatedUser(req)
            return req.projects
                .find(userId: authenticatedUser!.id, name: Constants.projectsArchiveName)
                .unwrap(or: ProjectControllerError.missingProject)
                .map { project in
                    ProjectDTO(model: translateProject(localization: localization, locale: authenticatedUser!.locale, project: project))
                }
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func getProjects(_ req: Request) -> Future<ProjectsDTO> {
        do {
            return req.projects
                .all(userId: try getAuthenticatedUser(req)!.id)
                .map { projects in
                    return ProjectsDTO(many: projects)
                }
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func updateProject(_ req: Request, updateProjectRequest: ProjectDTO) -> Future<HTTPStatus> {
        do {
            return req.projects
                .set(ProjectModel(id: updateProjectRequest.id, userId: try (getAuthenticatedUser(req)?.id)!, leftKey: updateProjectRequest.leftKey, rightKey: updateProjectRequest.rightKey, name: updateProjectRequest.name, color: updateProjectRequest.color, isCompleted: updateProjectRequest.isCompleted, level: updateProjectRequest.level, path: updateProjectRequest.path, defaultTagId: updateProjectRequest.defaultTag?.id))
                .flatMapErrorThrowing {
                    throw $0
                }
                .transform(to: .noContent)
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func deleteProject(_ req: Request, deleteProjectRequest: UUIDRequest) -> Future<HTTPStatus> {
        return req.projects
            .delete(id: deleteProjectRequest.id, force: false)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }
    
    public func deleteProjectOnDB(_ req: Request, deleteProjectRequest: UUIDRequest) -> Future<HTTPStatus> {
        return req.projects
            .delete(id: deleteProjectRequest.id, force: true)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }
}
