//
//  AttachmentType.swift
//  
//
//  Created by Thomas Benninghaus on 22.01.24.
//

import Foundation

public enum AttachmentType: String, Codable, CaseIterable {
    case anyFileType = "AnyFileType"
    case image = "Image"
    case audio = "Audio"
    case video = "Video"
    case emoji = "Emoji"
    case integration = "Integration"
    case none = "none"
    
    public var description: String {
        self.rawValue
    }
}
