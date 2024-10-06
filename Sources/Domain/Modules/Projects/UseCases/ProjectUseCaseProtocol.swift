//
//  ProjectUseCaseProtocol.swift
//
//
//  Created by Thomas Benninghaus on 27.12.23.
//


import Vapor
import Fluent
import DTO

public protocol ProjectUseCaseProtocol: UseCaseProtocol, ProjectUseCaseMockProtocol {
    func createProject(_ req: Request, createProjectRequest: ProjectDTO) throws -> Future<HTTPStatus>
    func getProject(_ req: Request, getProjectRequest: UUIDRequest) -> Future<ProjectDTO>
    func getProjects(_ req: Request) -> Future<ProjectsDTO>
    func updateProject(_ req: Request, updateProjectRequest: ProjectDTO) -> Future<HTTPStatus>
    func deleteProject(_ req: Request, deleteProjectRequest: UUIDRequest) -> Future<HTTPStatus>
    func deleteProjectOnDB(_ req: Request, deleteProjectRequest: UUIDRequest) -> Future<HTTPStatus>
}

public protocol ProjectUseCaseMockProtocol {
    func createProjectDemo(_ req: Request) -> Future<HTTPStatus>
}
