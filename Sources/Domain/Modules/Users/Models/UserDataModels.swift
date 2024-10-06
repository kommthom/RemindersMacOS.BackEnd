//
//  UserDataModels.swift
//
//
//  Created by Thomas Benninghaus on 27.05.24.
//

import Foundation
import DTO

public final class UserDataModels {
    public let userId: UUID
    public var settings: [SettingModel]
    public var tags: [TagModel]
    public var projects: [ProjectModel]
    public var timePeriods: [TimePeriodModel]
    public var rules: [RuleModel]
    
    public init(userId: UserModel.IDValue) {
        self.userId = userId
        self.settings = settingsMock
        self.tags = tagsMock
        self.projects = projectsMock
        self.timePeriods = timePeriodsMock
        self.rules = rulesMock
    }
    
    private var uuids: [UUID] { [0...35].map { int in UUID() } }
    
    private var settingsMock: [SettingModel] { [
        SettingModel(sortOrder: 1, scope: .sidebarOptionsType, name: "settings.show_count", description: "settings.show_count", valueType: .bool, boolValue: true, intValue: nil, stringValue: nil, idValue: nil, jsonValue: nil, userId: userId),
        SettingModel(sortOrder: 2, scope: .sidebarType, name: "settings.inbox", description: "settings.inbox", valueType: .json, boolValue: true, intValue: nil, stringValue: "tasks/inbox", idValue: nil, jsonValue: nil, userId: userId),
        SettingModel(sortOrder: 3, scope: .sidebarType, name: "settings.today", description: "settings.today", valueType: .string, boolValue: true, intValue: nil, stringValue: "tasks/today", idValue: nil, jsonValue: nil, userId: userId),
        SettingModel(sortOrder: 4, scope: .sidebarType, name: "settings.soon", description: "settings.soon", valueType: .string, boolValue: true, intValue: nil, stringValue: "tasks/soon", idValue: nil, jsonValue: nil, userId: userId),
        SettingModel(sortOrder: 5, scope: .sidebarType, name: "settings.filter", description: "settings.filter", valueType: .json, boolValue: true, intValue: nil, stringValue: nil, idValue: nil, jsonValue: "[]", userId: userId),
        SettingModel(sortOrder: 6, scope: .sidebarType, name: "settings.labels", description: "settings.labels", valueType: .string, boolValue: true, intValue: nil, stringValue: "tags/index", idValue: nil, jsonValue: nil, userId: userId),
        SettingModel(sortOrder: 7, scope: .sidebarType, name: "settings.done", description: "settings.done", valueType: .string, boolValue: true, intValue: nil, stringValue: "tasks/done", idValue: nil, jsonValue: nil, userId: userId)
    ] }
    private var tagsMock: [TagModel] { [
        TagModel(id: uuids[0], description: "tag.soon", color: CodableColor(wrappedValue: .blue), for: userId),
        TagModel(id: uuids[1], description: "tag.under_progress", color: CodableColor(wrappedValue: .brown), for: userId),
        TagModel(id: uuids[2], description: "tag.someday", color: CodableColor(wrappedValue: .cyan), for: userId),
        TagModel(id: uuids[3], description: "tag.waiting_for", color: CodableColor(wrappedValue: .darkGray), for: userId),
        TagModel(id: uuids[4], description: "tag.less_10min.", color: CodableColor(wrappedValue: .gray), for: userId),
        TagModel(id: uuids[5], description: "tag.weekend", color: CodableColor(wrappedValue: .green), for: userId),
        TagModel(id: uuids[6], description: "tag.next_steps.", color: CodableColor(wrappedValue: .lightGray), for: userId),
        TagModel(id: uuids[7], description: "tag.frequently", color: CodableColor(wrappedValue: .magenta), for: userId),
        TagModel(id: uuids[8], description: "tag.get_up", color: CodableColor(wrappedValue: .orange), for: userId),
        TagModel(id: uuids[9], description: "tag.banking", color: CodableColor(wrappedValue: .purple), for: userId),
        TagModel(id: uuids[10], description: "tag.shopping", color: CodableColor(wrappedValue: .red), for: userId),
        TagModel(id: uuids[11], description: "tag.hobby.", color: CodableColor(wrappedValue: .yellow), for: userId),
        TagModel(id: uuids[12], description: "tag.house", color: CodableColor(wrappedValue: .systemIndigo), for: userId),
        TagModel(id: uuids[13], description: "tag.reading.", color: CodableColor(wrappedValue: .systemMint), for: userId),
        TagModel(id: uuids[14], description: "tag.mac", color: CodableColor(wrappedValue: .systemPink), for: userId),
        TagModel(id: uuids[15], description: "tag.mobile", color: CodableColor(wrappedValue: .systemTeal), for: userId),
        TagModel(id: uuids[16], description: "tag.track", color: CodableColor(wrappedValue: .systemBlue), for: userId),
        TagModel(id: uuids[17], description: "tag.research", color: CodableColor(wrappedValue: .systemCyan), for: userId),
        TagModel(id: uuids[18], description: "tag.go_to_bed.", color: CodableColor(wrappedValue: .systemYellow), for: userId),
        TagModel(id: uuids[19], description: "tag.at_home", color: CodableColor(wrappedValue: .systemGreen), for: userId),
        TagModel(id: uuids[20], description: "tag.dinner.", color: CodableColor(wrappedValue: .systemRed), for: userId),
        TagModel(id: uuids[21], description: "tag.alexa", color: CodableColor(wrappedValue: .systemPurple), for: userId),
    ] }
    private var projectsMock: [ProjectModel] { [
        ProjectModel(id: userId, userId: userId , leftKey: 1, rightKey: 4, name: Constants.projectsRootName, color: nil, isCompleted: false, level: 1, path: "/", isSystem: true),
        ProjectModel(id: uuids[35], userId: userId, leftKey: 2, rightKey: 3, name: Constants.projectsArchiveName, color: nil, isCompleted: false, level: 2, path: "/\(Constants.projectsArchiveName)/", isSystem: true)
    ] }
    private var timePeriodsMock: [TimePeriodModel] { [
        TimePeriodModel(id: uuids[22], typeOfTime: .sleepingTime, from: "23:30", to: "08:30", day: nil, parentId: nil, for: userId),
        TimePeriodModel(id: uuids[23], typeOfTime: .normalWorkingTime, from: "10:00", to: "20:00", day: nil, parentId: nil, for: userId),
        TimePeriodModel(id: uuids[24], typeOfTime: .normalLeisureTime, from: "20:00", to: "23:30", day: nil, parentId: nil, for: userId),
        TimePeriodModel(id: uuids[25], typeOfTime: .normalLeisureTime, from: "08:30", to: "10:00", day: nil, parentId: nil, for: userId),
        TimePeriodModel(id: uuids[26], typeOfTime: .normalLeisureTimeWE, from: "09:30", to: "23:30", day: nil, parentId: nil, for: userId),
        TimePeriodModel(id: uuids[27], typeOfTime: .sleepingTimeWE, from: "23:30", to: "09:30", day: nil, parentId: nil, for: userId)
    ] }
    private var rulesMock: [RuleModel] { [
        RuleModel(id: uuids[28], description: "rule.archivewhencompleted", ruleType: .onEnd, actionType: .archive, for: userId),
        RuleModel(id: uuids[29], description: "rule.createnewwhencompleted", ruleType: .onEnd, actionType: .createTask, for: userId),
        RuleModel(id: uuids[30], description: "rule.opencalendarwhenstarted", ruleType: .onStart, actionType: .openCalendar, for: userId),
        RuleModel(id: uuids[31], description: "rule.openmailwhenstarted", ruleType: .onStart, actionType: .openMail, for: userId),
        RuleModel(id: uuids[32], description: "rule.openmusicwhenstarted", ruleType: .onStart, actionType: .openMusic, for: userId),
        RuleModel(id: uuids[33], description: "rule.readmetalhammerwhendue", ruleType: .onDue, actionType: .metalHammer, for: userId),
    ] }
}
