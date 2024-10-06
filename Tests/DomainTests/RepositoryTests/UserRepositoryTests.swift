//
//  UserRepositoryTests.swift
//
//
//  Created by Thomas Benninghaus on 29.12.23.
//

@testable import Domain
import Fluent
import XCTVapor

final class UserRepositoryTests: XCTestCase {
    var app: Application!
    var repository: UserRepositoryProtocol!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        repository = DatabaseUserRepository(database: app.db)
        try app.autoMigrate().wait()
    }
    
    override func tearDownWithError() throws {
        try app.autoRevert().wait()
        app.shutdown()
    }
    
    func testCreatingUser() throws {
        let user = UserModel(fullName: "Test User", email: "test@test.com", passwordHash: "123")
        try repository.create(user).wait()
        
        XCTAssertNotNil(user.id)
        
        let userRetrieved = try UserModel.find(user.id, on: app.db).wait()
        XCTAssertNotNil(userRetrieved)
    }
    
    func testDeletingUser() throws {
        let user = UserModel(fullName: "Test User", email: "test@test.com", passwordHash: "123")
        try user.create(on: app.db).wait()
        let count = try UserModel.query(on: app.db).count().wait()
        XCTAssertEqual(count, 1)
        
        try repository.delete(id: user.requireID(), force: false).wait()
        let countAfterDelete = try UserModel.query(on: app.db).count().wait()
        XCTAssertEqual(countAfterDelete, 0)
    }
    
    func testGetAllUsers() throws {
        let user = UserModel(fullName: "Test User", email: "test@test.com", passwordHash: "123")
        let user2 = UserModel(fullName: "Test User 2", email: "test2@test.com", passwordHash: "123")
        
        try user.create(on: app.db).wait()
        try user2.create(on: app.db).wait()
        
        let users = try repository.all().wait()
        XCTAssertEqual(users.count, 2)
    }
    
    func testFindUserById() throws {
        let user = UserModel(fullName: "Test User", email: "test@test.com", passwordHash: "123")
        try user.create(on: app.db).wait()
        
        let userFound = try repository.find(id: user.requireID()).wait()
        XCTAssertNotNil(userFound)
    }
    
    func testSetFieldValue() throws {
        let user = UserModel(fullName: "Test User", email: "test@test.com", passwordHash: "123", isEmailVerified: false)
        try user.create(on: app.db).wait()
        
        try repository.set(\.$isEmailVerified, to: true, for: user.requireID()).wait()
        
        let updatedUser = try UserModel.find(user.id!, on: app.db).wait()
        XCTAssertEqual(updatedUser!.isEmailVerified, true)
    }
    
    func testSetAllFieldValue() throws {
        let user = UserModel(fullName: "Test User", email: "test@test.com", passwordHash: "123", isEmailVerified: false)
        try user.create(on: app.db).wait()
        user.isEmailVerified = true
        
        repository.set(user)
        
        let updatedUser = try UserModel.find(user.id!, on: app.db).wait()
        XCTAssertEqual(updatedUser!.isEmailVerified, true)
    }
}
