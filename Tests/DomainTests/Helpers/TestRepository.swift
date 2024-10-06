//
//  TestRepository.swift
//  
//
//  Created by Thomas Benninghaus on 28.12.23.
//

@testable import Domain
import Vapor

protocol TestRepository: AnyObject {
    var eventLoop: EventLoop { get set }
}

extension TestRepository where Self: RequestServiceProtocol {
    func `for`(_ req: Request) -> Self {
        self.eventLoop = req.eventLoop
        return self
    }
}
