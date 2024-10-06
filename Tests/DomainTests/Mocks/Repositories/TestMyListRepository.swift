//
//  TestProjectRepository.swift
//
//
//  Created by Thomas Benninghaus on 28.12.23.
//

@testable import Domain
import Vapor
import FluentKit

class TestProjectRepository: ProjectRepositoryProtocol, TestRepository {
    var projects: [ProjectModel]
    var eventLoop: EventLoop
    
    init(projects: [ProjectModel] = [], eventLoop: EventLoop) {
        self.projects = projects
        self.eventLoop = eventLoop
    }
    
    func create(_ project: Domain.ProjectModel) -> NIOCore.EventLoopFuture<Void> {
        projects.append(project)
        return eventLoop.makeSucceededFuture(())
    }
    
    func delete(id: UUID) -> NIOCore.EventLoopFuture<Void> {
        projects.removeAll(where: { $0.id == id })
        return eventLoop.makeSucceededFuture(())
    }
    
    func all() -> NIOCore.EventLoopFuture<[Domain.ProjectModel]> {
        return eventLoop.makeSucceededFuture(projects)
    }
    
    func find(id: UUID?) -> NIOCore.EventLoopFuture<Domain.ProjectModel?> {
        let project = projects.first(where: { $0.id == id })
        return eventLoop.makeSucceededFuture(project)
    }
    
    func find(name: String) -> NIOCore.EventLoopFuture<Domain.ProjectModel?> {
        let project = projects.first(where: { $0.name == name })
        return eventLoop.makeSucceededFuture(project)
    }
    
    func set<Field>(_ field: KeyPath<Domain.ProjectModel, Field>, to value: Field.Value, for projectID: UUID) -> NIOCore.EventLoopFuture<Void> where Field : FluentKit.QueryableProperty, Field.Model == Domain.ProjectModel {
        return eventLoop.makeSucceededFuture(())
    }
    
    func count() -> NIOCore.EventLoopFuture<Int> {
        return eventLoop.makeSucceededFuture(projects.count)
    }
    
    func set(_ project: Domain.ProjectModel) -> NIOCore.EventLoopFuture<Void> {
        projects = projects.map { item in
            var copyItem = item
            if copyItem.id == project.id {
                    copyItem = project
                }
                return copyItem
            }
        return eventLoop.makeSucceededFuture(())
    }
}
