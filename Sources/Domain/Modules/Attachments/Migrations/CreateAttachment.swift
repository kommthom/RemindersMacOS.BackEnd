//
//  CreateAttachment.swift
//  
//
//  Created by Thomas Benninghaus on 22.01.24.
//

import Fluent
import DTO

public struct CreateAttachment: Migration {
    public init() { }
    
    public func prepare(on database: Database) -> Future<Void> {
        return database.createEnum("attachmenttype", allCases: AttachmentType.allCases.compactMap { $0.rawValue } )
            .flatMap { attachmenttype in
                return database.schema("attachments").ignoreExisting()
                    .id()
                    .field("comment", .string, .required)
                    .field("attachmenttype", attachmenttype)
                    .field("filename", .string)
                    .field("attachment", .data, .required)
                    .field("deleted_at", .datetime)
                    .field("task_id", .uuid, .required, .references("tasks", "id", onDelete: .cascade))
                    .create()
            }
    }
    
    public func revert(on database: Database) -> Future<Void> {
        return database.schema("attachments").delete()
    }
}
