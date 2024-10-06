//
//  DatabaseUploadRepository.swift
//
//
//  Created by Thomas Benninghaus on 01.05.24.
//

import Vapor
import Fluent

public struct DatabaseUploadRepository: UploadRepositoryProtocol, DatabaseRepositoryProtocol {
    public let database: Database
    private let logger = Logger(label: "reminders.backend.uploads")
    
    public func create(_ upload: UploadModel) -> Future<Void> {
        logger.info("Create Upload: \(upload.$fileName)")
        return upload
            .create(on: database)
            .flatMapErrorThrowing {
                if let dbError = $0 as? DatabaseError, dbError.isConstraintFailure {
                    logger.error("Create Upload: duplicate key -> \(upload.$fileName)")
                    throw UploadControllerError.unableToCreateNewRecord
                }
                logger.error("Create Upload: error -> \($0.localizedDescription)")
                throw $0
            }
    }
    
    public func delete(id: UUID) -> Future<Void> {
        return UploadModel
            .query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    public func all(for attachmentId: UUID) -> Future<[UploadModel]> {
        return UploadModel
            .query(on: database)
            .filter(\.$attachment.$id == attachmentId)
            .all()
    }
    
    public func find(id: UUID?) -> Future<UploadModel?> {
        return UploadModel
            .find(id, on: database)
    }
    
    public func count(for attachmentId: UUID) -> Future<Int> {
        return UploadModel
            .query(on: database)
            .filter(\.$attachment.$id == attachmentId)
            .count()
    }

    public init(database: Database) {
        self.database = database
    }
}

extension Application.Repositories {
    public var uploads: UploadRepositoryProtocol {
        guard let storage = storage.makeUploadRepository else {
            fatalError("UploadRepository not configured, use: app.uploadRepository.use()")
        }
        
        return storage(app)
    }
    
    public func use(_ make: @escaping (Application) -> (UploadRepositoryProtocol)) {
        storage.makeUploadRepository = make
    }
}
