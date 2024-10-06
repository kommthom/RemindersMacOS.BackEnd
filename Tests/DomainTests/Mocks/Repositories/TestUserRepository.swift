//
//  TestUserModelRepository.swift
//  
//
//  Created by Thomas Benninghaus on 28.12.23.
//

@testable import Domain
import Vapor
import Fluent

class TestUserRepository: UserRepositoryProtocol, TestRepository {
    func set(_ user: Domain.UserModel) -> NIOCore.EventLoopFuture<Void> {
        users = users.map { item in
            var copyItem = item
            if copyItem.id == user.id {
                    copyItem = user
                }
                return copyItem
            }
        return eventLoop.makeSucceededFuture(())
    }
    
    var users: [UserModel]
    var eventLoop: EventLoop
    
    init(users: [UserModel] = [UserModel](), eventLoop: EventLoop) {
        self.users = users
        self.eventLoop = eventLoop
    }
    
    func create(_ user: UserModel) -> EventLoopFuture<Void> {
        user.id = UUID()
        users.append(user)
        return eventLoop.makeSucceededFuture(())
    }
    
    func delete(id: UUID) -> EventLoopFuture<Void> {
        users.removeAll(where: { $0.id == id })
        return eventLoop.makeSucceededFuture(())
    }
    
    func all() -> EventLoopFuture<[UserModel]> {
        return eventLoop.makeSucceededFuture(users)
    }
    
    func find(id: UUID?) -> EventLoopFuture<UserModel?> {
        let user = users.first(where: { $0.id == id })
        return eventLoop.makeSucceededFuture(user)
    }
    
    func find(email: String) -> EventLoopFuture<UserModel?> {
        let user = users.first(where: { $0.email == email })
        return eventLoop.makeSucceededFuture(user)
    }
    
    func set<Field>(_ field: KeyPath<UserModel, Field>, to value: Field.Value, for userID: UUID) -> EventLoopFuture<Void> where Field : QueryableProperty, Field.Model == UserModel {
        let user = users.first(where: { $0.id == userID })!
        user[keyPath: field].value = value
        return eventLoop.makeSucceededFuture(())
    }
    
    func count() -> EventLoopFuture<Int> {
        return eventLoop.makeSucceededFuture(users.count)
    }
}

