//
//  AttachmentsDTO.swift
//
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Vapor

public struct AttachmentsDTO: Content {
    public var attachments: [AttachmentDTO]

    public init(attachments: [AttachmentDTO] = []) {
        self.attachments = attachments
    }
}
