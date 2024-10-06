//
//  ActionType.swift
//
//
//  Created by Thomas Benninghaus on 23.01.24.
//

import Foundation

public enum ActionType: String, Codable, CustomStringConvertible, CaseIterable {
    case archive = "Archive"
    case openMail = "Open_Mail"
    case openCalendar = "Open_Calendar"
    case openMusic = "Open_Music"
    case createTask = "Create_Task"
    case metalHammer = "Load_MetalHammer"
    
    public var description: String {
        self.rawValue
    }
}
