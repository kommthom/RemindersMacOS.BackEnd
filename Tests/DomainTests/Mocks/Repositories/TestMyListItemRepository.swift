//
//  TestTaskRepository.swift
//  
//
//  Created by Thomas Benninghaus on 28.12.23.
//

@testable import Domain
import Vapor
import FluentKit

class TestTaskRepository: TaskRepositoryProtocol, TestRepository {
    var tasks: [TaskModel]
    var eventLoop: EventLoop
    
    init(tasks: [TaskModel] = [], eventLoop: EventLoop) {
        self.tasks = tasks
        self.eventLoop = eventLoop
    }
    func create(_ task: Domain.TaskModel) -> NIOCore.EventLoopFuture<Void> {
        tasks.append(task)
        return eventLoop.makeSucceededFuture(())
    }
    
    func delete(id: UUID) -> NIOCore.EventLoopFuture<Void> {
        tasks.removeAll(where: { $0.id == id })
        return eventLoop.makeSucceededFuture(())
    }
    
    func all() -> NIOCore.EventLoopFuture<[Domain.TaskModel]> {
        return eventLoop.makeSucceededFuture(tasks)
    }
    
    func find(id: UUID?) -> NIOCore.EventLoopFuture<Domain.TaskModel?> {
        let task = tasks.first(where: { $0.id == id })
        return eventLoop.makeSucceededFuture(task)
    }
    
    func find(project: UUID?) -> NIOCore.EventLoopFuture<[Domain.TaskModel]> {
        let tasks = tasks.filter( { $0.project.id == project })
        return eventLoop.makeSucceededFuture(tasks)
    }
    
    func set<Field>(_ field: KeyPath<Domain.TaskModel, Field>, to value: Field.Value, for taskID: UUID) -> NIOCore.EventLoopFuture<Void> where Field : FluentKit.QueryableProperty, Field.Model == Domain.TaskModel {
        return eventLoop.makeSucceededFuture(())
    }
    
    func count() -> NIOCore.EventLoopFuture<Int> {
        return eventLoop.makeSucceededFuture(tasks.count)
    }
    
    func set(_ task: Domain.TaskModel) -> NIOCore.EventLoopFuture<Void> {
        tasks = tasks.map { item in
            var copyItem = item
            if copyItem.id == task.id {
                    copyItem = task
                }
                return copyItem
            }
        return eventLoop.makeSucceededFuture(())
    }
}
