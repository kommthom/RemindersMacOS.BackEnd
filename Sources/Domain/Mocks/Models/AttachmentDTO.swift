//
//  AttachmentDTO.swift
//
//
//  Created by Thomas Benninghaus on 16.02.24.
//

public struct AttachmentDTO {
    public var id: UUID?
    public var comment: String
    public var files: UploadsDTO?
    public var task_id: UUID
    
    public init(id: UUID? = nil, comment: String, files: UploadsDTO?, taskId: UUID) {
        self.id = id
        self.comment = comment
        self.files = files
        self.task_id = taskId
    }
}

extension AttachmentDTO: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("comment", as: String.self, is: .count(5...))
    }
}
