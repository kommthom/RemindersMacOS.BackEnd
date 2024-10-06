//
//  EmailVerificationTests.swift
//
//
//  Created by Thomas Benninghaus on 08.01.24.
//

@testable import Domain
import Fluent
import XCTVapor
import Crypto
import Resources

final class EmailVerificationTests: XCTestCase {
    var app: Application!
    var testWorld: TestWorld!
    let verifyURL = "api/auth/email-verification"
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        self.testWorld = try TestWorld(app: app)
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testVerifyingEmailHappyPath() throws {
        let user = UserModel(fullName: "Test User", email: "test@test.com", passwordHash: "123")
        try app.repositories.users.create(user).wait()
        let expectedHash = SHA256.hash("token123")
        
        let emailToken = EmailToken(userID: try user.requireID(), token: expectedHash)
        try app.repositories.emailTokens.create(emailToken).wait()
        
        try app.test(.GET, verifyURL, beforeRequest: { req in
            try req.query.encode(["token": "token123"])
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let user = try XCTUnwrap(app.repositories.users.find(id: user.id!).wait())
            XCTAssertEqual(user.isEmailVerified, true)
            let token = try app.repositories.emailTokens.find(userID: user.requireID()).wait()
            XCTAssertNil(token)
        })
    }
    
    func testVerifyingEmailWithInvalidTokenFails() throws {
        try app.test(.GET, verifyURL, beforeRequest: { req in
            try req.query.encode(["token": "blabla"])
        }, afterResponse: { res in
            XCTAssertResponseError(res, AuthenticationError.emailTokenNotFound)
        })
    }
    
    func testVerifyingEmailWithExpiredTokenFails() throws {
        let user = UserModel(fullName: "Test User", email: "test@test.com", passwordHash: "123")
        try app.repositories.users.create(user).wait()
        let expectedHash = SHA256.hash("token123")
        let emailToken = EmailToken(userID: try user.requireID(), token: expectedHash, expiresAt: Date().addingTimeInterval(-Constants.EMAIL_TOKEN_LIFETIME - 1) )
        try app.repositories.emailTokens.create(emailToken).wait()
        
        try app.test(.GET, verifyURL, beforeRequest: { req in
            try req.query.encode(["token": "token123"])
        }, afterResponse: { res in
            XCTAssertResponseError(res, AuthenticationError.emailTokenHasExpired)
        })
    }
    
    func testResendEmailVerification() throws {
        app.randomGenerators.use(.rigged(value: "emailtoken"))
        
        let user = UserModel(fullName: "Test User", email: "tbenninghaus@gmx.de", passwordHash: "123")
        try app.repositories.users.create(user).wait()
        
        let content = SendEmailVerificationRequest(email: "tbenninghaus@gmx.de")
        
        try app.test(.POST, verifyURL, content: content, afterResponse: { res in
            XCTAssertEqual(res.status, .noContent)
            let emailToken = try app.repositories.emailTokens.find(token: SHA256.hash("emailtoken")).wait()
            XCTAssertNotNil(emailToken)
            
            let job = try XCTUnwrap(app.queues.test.first(EmailJob.self))
            XCTAssertEqual(job.recipient.address, "tbenninghaus@gmx.de")
            XCTAssertEqual(job.templateName, EmailTemplateType.verificationEmail.templateName)
            //XCTAssertEqual(job.email.templateData["verify_url"], "http://api.local/auth/email-verification?token=emailtoken")
        })
    }
}



