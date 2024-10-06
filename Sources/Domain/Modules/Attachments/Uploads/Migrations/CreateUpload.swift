//
//  CreateUpload.swift
//
//
//  Created by Thomas Benninghaus on 01.05.24.
//

import Fluent
import DTO

public struct CreateUpload: Migration {
    public init() { }
    
    public func prepare(on database: Database) -> Future<Void> {
        return database.createEnum("attachmenttype", allCases: AttachmentType.allCases.compactMap { $0.rawValue } )
            .flatMap { attachmenttype in
                return database.schema("uploads").ignoreExisting()
                    .id()
                    .field("attachmenttype", attachmenttype, .required)
                    .field("filename", .string, .required)
                    .field("originalfilename", .string, .required)
                    .field("deleted_at", .datetime)
                    .field("attachment_id", .uuid, .required, .references("attachments", "id", onDelete: .cascade))
                    .create()
            }
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("uploads").delete()
    }
}
