//
//  AuthenticationTests.swift
//  
//
//  Created by Thomas Benninghaus on 28.12.23.
//

@testable import Domain
import Fluent
import DTO
import XCTVapor

final class AuthenticationTests: XCTestCase {
    var app: Application!
    var testWorld: TestWorld!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        self.testWorld = try TestWorld(app: app)
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testLoginUserNotVerified() throws {
        let password = "abcd1234"
        let passwordHash = try Bcrypt.hash(password)
        let user = UserModel(fullName: "Test User", email: "test@test.com", passwordHash: passwordHash, isAdmin: true, isEmailVerified: false, imageURL: "https://google.com")
        try app.repositories.users.create(user).wait()
        
        try app.test( .POST,
                      "api/auth/login",
                      //headers: HTTPHeaders( [("alg", "RS256"), ("typ", "JWT"), ("kid", "<value>")] ),
                      login: LoginRequest(email: user.email, password: password),
                      afterResponse: { res in
                        XCTAssertEqual(res.status, .unauthorized)
                        }
            )
    }
    
    func testLoginUserVerified() throws {
        let password = "abcd1234"
        let passwordHash = try Bcrypt.hash(password)
        let user = UserModel(fullName: "Test User", email: "test@test.com", passwordHash: passwordHash, isAdmin: true, isEmailVerified: true, imageURL: "https://google.com")
        try app.repositories.users.create(user).wait()
        
        try app.test( .POST,
                      "api/auth/login",
                      //headers: HTTPHeaders( [("alg", "RS256"), ("typ", "JWT"), ("kid", "<value>")] ),
                      login: LoginRequest(email: user.email, password: password),
                      afterResponse: { res in
                        XCTAssertEqual(res.status, .ok)
                        XCTAssertContent(LoginResponse.self, res) { response in
                            XCTAssertEqual(response.user.email, "test@test.com")
                            XCTAssertEqual(response.user.fullName, "Test User")
                            XCTAssertNotEqual(response.accessToken, "")
                            XCTAssertNotEqual(response.refreshToken, "")
                        }
                    }
            )
    }
    
    func testGettingCurrentUser() throws {
        let user = UserModel(fullName: "Test User", email: "test@test.com", passwordHash: "123", isAdmin: true, isEmailVerified: false, imageURL: "https://google.com")
        try app.repositories.users.create(user).wait()
        
        try app.test( .GET, 
                      "api/auth/me",
                      //headers: HTTPHeaders( [("alg", "RS256"), ("typ", "JWT"), ("kid", "<value>")] ),
                      user: user,
                      afterResponse: { res in
                        XCTAssertEqual(res.status, .ok)
                        XCTAssertContent(UserDTO.self, res) { userContent in
                            XCTAssertEqual(userContent.email, "test@test.com")
                            XCTAssertEqual(userContent.fullName, "Test User")
                            XCTAssertEqual(userContent.isAdmin, true)
                            XCTAssertEqual(userContent.imageURL, "https://google.com")
                            XCTAssertEqual(userContent.id, user.id)
                        }
                    }
            )
    }
}
