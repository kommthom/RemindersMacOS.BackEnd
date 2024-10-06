//
//  TestWorld.swift
//
//
//  Created by Thomas Benninghaus on 28.12.23.
//

@testable import Domain
import Fluent
import XCTVapor
import XCTQueues

class TestWorld {
    let app: Application
    
    // Repositories
    private var tokenRepository: TestRefreshTokenRepository
    private var userRepository: TestUserRepository
    private var emailTokenRepository: TestEmailTokenRepository
    private var projectRepository: TestProjectRepository
    private var taskRepository: TestTaskRepository
    private var passwordTokenRepository: TestPasswordTokenRepository
    
    private var refreshtokens: [RefreshToken] = []
    private var users: [UserModel] = []
    private var emailTokens: [EmailToken] = []
    private var passwordTokens: [PasswordToken] = []
    private var projects: [ProjectModel] = []
    private var tasks: [TaskModel] = []
    
    init(app: Application) throws {
        self.app = app
        
        self.tokenRepository = TestRefreshTokenRepository(tokens: refreshtokens, eventLoop: app.eventLoopGroup.next())
        self.userRepository = TestUserRepository(users: users, eventLoop: app.eventLoopGroup.next())
        self.emailTokenRepository = TestEmailTokenRepository(tokens: emailTokens, eventLoop: app.eventLoopGroup.next())
        self.passwordTokenRepository = TestPasswordTokenRepository(tokens: passwordTokens, eventLoop: app.eventLoopGroup.next())
        self.projectRepository = TestProjectRepository(projects: projects, eventLoop: app.eventLoopGroup.next())
        self.taskRepository = TestTaskRepository(tasks: tasks, eventLoop: app.eventLoopGroup.next())
        
        app.repositories.use { _ in self.tokenRepository }
        app.repositories.use { _ in self.userRepository }
        app.repositories.use { _ in self.emailTokenRepository }
        app.repositories.use { _ in self.passwordTokenRepository }
        app.repositories.use { _ in self.projectRepository }
        app.repositories.use { _ in self.taskRepository }
        
        app.queues.use(.test)
        app.smtp.use(.fake)
        app.config = .init(frontendURL: "127.0.0.1", port: "8080", noReplyEmail: "no-reply@testing.local")
    }
}



