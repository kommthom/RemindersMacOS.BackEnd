//
//  Application+Helpers.swift
//
//
//  Created by Thomas Benninghaus on 28.12.23.
//

@testable import Domain
import XCTVapor
import DTO

extension Application {
    // Authenticated test method
    @discardableResult
    func test<C: Content>(
        _ method: HTTPMethod,
        _ path: String,
        headers: HTTPHeaders = [:],
        accessToken: String? = nil,
        user: UserModel? = nil,
        content: C,
        afterResponse: (XCTHTTPResponse) throws -> () = { _ in },
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> XCTApplicationTester {
        var headers = headers
        
        if let token = accessToken {
            headers.add(name: "Authorization", value: "Bearer \(token)")
        } else if let user = user {
            let payload = try Payload(with: user, localization: {
                $0
            })
            let accessToken = try self.jwt.signers.sign(payload)
            
            headers.add(name: "Authorization", value: "Bearer \(accessToken)")
        }
        
        return try test(method, path, headers: headers, beforeRequest: { req in
            try req.content.encode(content, as: .urlEncodedForm)
        }, afterResponse: afterResponse)
    }
    
    @discardableResult
    func test(
        _ method: HTTPMethod,
        _ path: String,
        headers: HTTPHeaders = [:],
        user: UserModel,
        afterResponse: (XCTHTTPResponse) throws -> () = { _ in },
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> XCTApplicationTester {
        let payload = try Payload(with: user, localization: {
            $0
        })
        let accessToken = try self.jwt.signers.sign(payload)
        var headers = headers
        headers.add(name: "Authorization", value: "Bearer \(accessToken)")
        return try test(method, path, headers: headers, afterResponse: afterResponse)
    }
    
    @discardableResult
    func test(
        _ method: HTTPMethod,
        _ path: String,
        headers: HTTPHeaders = [:],
        login: LoginRequest,
        afterResponse: (XCTHTTPResponse) throws -> () = { _ in },
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> XCTApplicationTester {
        return try test(method, path, headers: headers, beforeRequest: { req in
            try req.content.encode(login)
        }, afterResponse: afterResponse)
    }
}

