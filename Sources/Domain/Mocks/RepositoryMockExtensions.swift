//
//  RepositoryMockExtensions.swift
//
//
//  Created by Thomas Benninghaus on 15.04.24.
//

import Foundation
import Vapor
import Fluent
import AppKit
import DTO

extension DatabaseProjectRepository: ProjectRepositoryMockProtocol {
    public func getDemo(_ exampleNo: Int, userId: UUID, relativeKey: Int, defaultTagId: UUID? = nil) -> ProjectModel {
        let name = "\(Constants.projectsDemoProjectName) \(exampleNo)"
        switch exampleNo {
            case 1: return ProjectModel(userId: userId, leftKey: relativeKey, rightKey: relativeKey + 1, name: name, color: CodableColor(wrappedValue: .green), defaultTagId: defaultTagId)
            default: return ProjectModel(userId: userId, leftKey: relativeKey, rightKey: relativeKey + 1, name: name, color: CodableColor(wrappedValue: .blue), defaultTagId: defaultTagId)
        }
    }
    
    public func createDemoProjects(userId: UUID, defaultTagId: [UUID?] = [nil, nil]) -> Future<[ProjectModel]> {
        let names: [(String, Int)] = [(Constants.projectsNoProjectName, -1), ("\(Constants.projectsDemoProjectName) 0", 0), ("\(Constants.projectsDemoProjectName) 1", 1)]
        return names
            .map { (name, exampleNo) in
                switch exampleNo {
                    case 0:
                        return self
                            .find(userId: userId, name: Constants.projectsArchiveName)
                            .flatMap { archiveModel in
                                if let _ = archiveModel {
                                    let demoModel = getDemo(exampleNo, userId: userId, relativeKey: archiveModel!.leftKey, defaultTagId: defaultTagId[exampleNo])
                                    return self
                                        .find(userId: userId, name: demoModel.name)
                                        .flatMap { projectNil in
                                            if let _ = projectNil { return database.eventLoop.makeSucceededFuture(projectNil!) }
                                            return create(demoModel)
                                                .map { return demoModel }
                                        }
                                } else { return database.eventLoop.makeFailedFuture(ProjectControllerError.missingProject) }
                            }
                    case 1:
                        return self
                            .find(userId: userId, name: names[1].0)
                            .flatMap { demoModel0 in
                                if let _ = demoModel0 {
                                    let demoModel = getDemo(exampleNo, userId: userId, relativeKey: demoModel0!.rightKey, defaultTagId: defaultTagId[exampleNo])
                                    return self
                                        .find(userId: userId, name: demoModel.name)
                                        .flatMap { projectNil in
                                            if let _ = projectNil { return database.eventLoop.makeSucceededFuture(projectNil!) }
                                            return create(demoModel)
                                                .map { demoModel }
                                        }
                                } else { return database.eventLoop.makeFailedFuture(ProjectControllerError.missingProject)}
                            }
                    default: //case -1:
                        return self
                            .find(userId: userId, name: name)
                            .flatMap { inboxModel in
                                inboxModel != nil ? database.eventLoop.makeSucceededFuture(inboxModel!) : database.eventLoop.makeFailedFuture(ProjectControllerError.missingProject)
                            }
                }
            }
            .flatten(on: database.eventLoop)
    }
}

extension DatabaseTaskRepository: TaskRepositoryMockProtocol {
    public func getDemo(_ exampleNo: Int, projectId: UUID) -> [TaskModel] {
        return switch exampleNo {
            case 1: [TaskModel(id: UUID(), itemDescription: "\(Constants.projectsDemoTaskName) 3", title: "title: \(Constants.projectsDemoTaskName) 3", priority: .none, isCompleted: false, homepage: nil, dutyPoints: 2, funPoints: 0, duration: 2.0, isCalendarEvent: false, breakAfter: 2.0, archivedPath: nil, parentItemId: nil, projectId: projectId)]
            case 2: [TaskModel(id: UUID(), itemDescription: "\(Constants.projectsDemoTaskName) 4", title: "title: \(Constants.projectsDemoTaskName) 4", priority: .P2, isCompleted: false, homepage: "https://google.com", dutyPoints: 0, funPoints: 2, duration: 0.25, isCalendarEvent: false, breakAfter: 2.0, archivedPath: nil, parentItemId: nil, projectId: projectId),
                     TaskModel(id: UUID(), itemDescription: "\(Constants.projectsDemoTaskName) 5", title: "title: \(Constants.projectsDemoTaskName) 5", priority: .P6, isCompleted: false, homepage: "https://hello.world", dutyPoints: 3, funPoints: 0, duration: 0.25, isCalendarEvent: false, breakAfter: 0.25, archivedPath: nil, parentItemId: nil, projectId: projectId)]
            default: [TaskModel(id: UUID(), itemDescription: "\(Constants.projectsDemoTaskName) 0", title: "title: \(Constants.projectsDemoTaskName) 0", priority: .P4, isCompleted: false, homepage: nil, dutyPoints: 1, funPoints: 1, duration: 1.5, isCalendarEvent: false, breakAfter: 2.0, archivedPath: nil, parentItemId: nil,  projectId: projectId),
                      TaskModel(id: UUID(), itemDescription: "\(Constants.projectsDemoTaskName) 1", title: "title: \(Constants.projectsDemoTaskName) 1", priority: .none, isCompleted: false, homepage: "https://hello.world", dutyPoints: 0, funPoints: 5, duration: 1.0, isCalendarEvent: false, archivedPath: nil, parentItemId: nil,  projectId: projectId),
                      TaskModel(id: UUID(), itemDescription: "\(Constants.projectsDemoTaskName) 2", title: "title: \(Constants.projectsDemoTaskName) 2", priority: .P3, isCompleted: false, homepage: "https://hello.world", dutyPoints: 10, funPoints: 0, duration: 0.5, isCalendarEvent: false, archivedPath: nil, parentItemId: nil,  projectId: projectId)]  //0
         }
    }
    
    public func createDemo(_ exampleNo: Int, projectId: UUID) -> Future<[(Int, TaskModel)]> {
        return self
            .getDemo(exampleNo, projectId: projectId) // -> [TaskModel]
            .compactMap { task in
                let indexTask = Int(task.itemDescription.split(separators: [" "]).last ?? "0") ?? 0
                return self
                    .create(task)
                    .map { return (indexTask, task) }
            }
            .flatten(on: database.eventLoop)
    }
}

extension DatabaseTimePeriodRepository: TimePeriodRepositoryMockProtocol {
    public func getDemo(_ exampleNo: Int, userId: UUID) -> Future<[TimePeriodModel]> {
        switch exampleNo {
            case 1:
                let newTimePeriod = TimePeriodModel(id: UUID(), typeOfTime: .individual, from: "16:00", to: "18:00", day: nil, parentId: nil, for: userId)
                return self
                    .find(userId: userId, typeOfTime: .individual, from: newTimePeriod.from, to: newTimePeriod.to)
                    .flatMap { timePeriod in
                        if let _ = timePeriod { return database.eventLoop.makeSucceededFuture([timePeriod!]) }
                        return self
                            .create(newTimePeriod)
                            .map { return [newTimePeriod] }
                    }
            case 2, 3, 4: return database.eventLoop.makeSucceededFuture([])
            case 5: return self.getByTypes(userId: userId, typesOfTime: [.normalLeisureTimeWE, .normalWorkingTime])
            default: return self.getByTypes(userId: userId, typesOfTime: [.normalWorkingTime])
        }
    }
    
    public func createDemo(_ exampleNo: Int, 
                           userId: UUID,
                           createRepetition: @escaping (_ timePeriods: [TimePeriodModel]) -> Future<RepetitionModel>
                          ) -> Future<[TimePeriodModel]> {
        return self
            .getDemo(exampleNo, userId: userId) // -> Future<[TimePeriodModel]>
            .flatMap { timePeriods in
                return createRepetition(timePeriods)
                    .flatMap { repetition in
                        return self
                            .createLinks(repetitionId: repetition.id!, timePeriods: timePeriods)
                            .map { return timePeriods }
                    }
                
            }
    }
}

extension DatabaseRepetitionRepository : RepetitionRepositoryMockProtocol {
    public func getDemo(_ exampleNo: Int, locale: LocaleIdentifier = .de_DE, taskId: UUID, timePeriods: [TimePeriodModel]) -> RepetitionModel? {
        let factory = RepetitionFactory(locale: locale)
        let tpDTO: TimePeriodsDTO = TimePeriodsDTO(many: timePeriods)
        return switch exampleNo {
            case 1: RepetitionModel(from: factory.create(id: UUID(), taskId: taskId, repetitionText: "jeden! montag viertelstündlich", timePeriods: tpDTO)!)
            case 2: nil
            case 3: RepetitionModel(from: factory.create(id: UUID(), taskId: taskId, repetitionText: "jedes jahr jede 20. woche jeden Mittwoch 19:15 max 2", timePeriods: .init())!)
            case 4: nil
            case 5: RepetitionModel(from: factory.create(id: UUID(), taskId: taskId, repetitionText: "jeden! 2. ultimo ab 30.06.2024", timePeriods: tpDTO)!)
            default: RepetitionModel(from: factory.create(id: UUID(), taskId: taskId, repetitionText: "jede! 2. woche freitags stündlich bis 30.06.2024", timePeriods: tpDTO)!)
        }
    }
    
    public func createDemo(_ exampleNo: Int, locale: LocaleIdentifier = .de_DE, taskId: UUID, timePeriods: [TimePeriodModel]) -> Future<RepetitionModel> {
        if let repetition = self
            .getDemo(exampleNo, locale: locale, taskId: taskId, timePeriods: timePeriods) { // -> RepetitionModel
            return self
                .create(repetition)
                .map { return repetition }
                
        } else { return database.eventLoop.makeFailedFuture(RepetitionControllerError.unableToCreateNewRecord) }
    }
}

extension DatabaseUploadRepository: UploadRepositoryMockProtocol {
    public func getDemo(_ exampleNo: Int, attachmentId: UUID) -> [UploadModel] {
        return switch exampleNo {
        case 1: [UploadModel(id: UUID(), attachmentType: .image, fileName: "zont.png", originalFileName: "zont.png", attachmentId: attachmentId)]
            case 2: [UploadModel(id: UUID(), attachmentType: .image, fileName: "zustellung.png", originalFileName: "zustellung.png", attachmentId: attachmentId)]
        case 3: []
        case 4: [UploadModel(id: UUID(), attachmentType: .image, fileName: "zont.png", originalFileName: "zont.png", attachmentId: attachmentId),
                 UploadModel(id: UUID(), attachmentType: .image, fileName: "zustellung.png", originalFileName: "zustellung.png", attachmentId: attachmentId)]
        case 5: []
            default: [UploadModel(id: UUID(), attachmentType: .image, fileName: "zwave.png", originalFileName: "zwave.png", attachmentId: attachmentId),
                      UploadModel(id: UUID(), attachmentType: .image, fileName: "zont.png", originalFileName: "zont.png", attachmentId: attachmentId),
                      UploadModel(id: UUID(), attachmentType: .image, fileName: "zustellung.png", originalFileName: "zustellung.png", attachmentId: attachmentId)]  //0
         }
    }
    
    public func createDemo(_ exampleNo: Int, attachmentId: UUID) -> Future<[UploadModel]> {
        return self
           .getDemo(exampleNo, attachmentId: attachmentId)
           .compactMap { upload in
               return self
                   .create(upload)
                   .map { return upload }
           }
           .flatten(on: database.eventLoop)
        }
}

extension DatabaseAttachmentRepository: AttachmentRepositoryMockProtocol {
    public func getDemo(_ exampleNo: Int, taskId: UUID) -> [AttachmentModel] {
        return [AttachmentModel(id: UUID(), comment: "ugly comment no. \(exampleNo) made easy from files", taskId: taskId)]
    }
    
    public func createDemo(_ exampleNo: Int, taskId: UUID) -> Future<[AttachmentModel]> {
        return self
           .getDemo(exampleNo, taskId: taskId)
           .compactMap { attachment in
               return self
                   .create(attachment)
                   .map { return attachment }
           }
           .flatten(on: database.eventLoop)
    }
}

extension DatabaseHistoryRepository: HistoryRepositoryMockProtocol {
    public func getDemo(_ exampleNo: Int, taskId: UUID) -> [HistoryModel] {
        return switch exampleNo {
            case 1: [HistoryModel(id: UUID(), historyType: .create, taskId: taskId),
                            HistoryModel(id: UUID(), historyType: .begin, taskId: taskId),
                            HistoryModel(id: UUID(), historyType: .end, taskId: taskId),
                            HistoryModel(id: UUID(), historyType: .archive, taskId: taskId)]
            case 2: [HistoryModel(id: UUID(), historyType: .create, taskId: taskId),
                            HistoryModel(id: UUID(), historyType: .begin, taskId: taskId),
                            HistoryModel(id: UUID(), historyType: .pause, taskId: taskId),
                            HistoryModel(id: UUID(), historyType: .begin, taskId: taskId)]
            case 3: [HistoryModel(id: UUID(), historyType: .create, taskId: taskId),
                            HistoryModel(id: UUID(), historyType: .begin, taskId: taskId),
                            HistoryModel(id: UUID(), historyType: .end, taskId: taskId)]
            case 4: [HistoryModel(id: UUID(), historyType: .create, taskId: taskId)]
            case 5: [HistoryModel(id: UUID(), historyType: .create, taskId: taskId),
                            HistoryModel(id: UUID(), historyType: .begin, taskId: taskId)]
            default: [HistoryModel(id: UUID(), historyType: .create, taskId: taskId)]  //0
         }
    }
    
    public func createDemo(_ exampleNo: Int, taskId: UUID, userId: UUID) -> Future<[HistoryModel]> {
        return self
           .getDemo(exampleNo, taskId: taskId)
           .compactMap { history in
               return self
                   .create(history)
                   .map { return history }
           }
           .flatten(on: database.eventLoop)
    }
}

extension DatabaseRuleRepository: RuleRepositoryMockProtocol {
    public func getDemo(_ exampleNo: Int, userId: UUID) -> Future<[RuleModel]> {
        let rules = switch exampleNo {
            case 1: [RuleModel(id: UUID(), description: "rule.archivewhencompleted", ruleType: .onEnd, actionType: .archive, for: userId),
                     RuleModel(id: UUID(), description: "rule.createnewwhencompleted", ruleType: .onEnd, actionType: .createTask, for: userId),
                     RuleModel(id: UUID(), description: "rule.opencalendarwhenstarted", ruleType: .onStart, actionType: .openCalendar, for: userId),
                            RuleModel(id: UUID(), description: "archive when ended", ruleType: .onEnd, actionType: .archive, args: [], for: userId)]
            case 2: [RuleModel(id: UUID(), description: "rule.archivewhencompleted", ruleType: .onEnd, actionType: .archive, for: userId),
                     RuleModel(id: UUID(), description: "do something on break", ruleType: .onBreak, actionType: .openMusic, for: userId)]
            case 3: [RuleModel(id: UUID(), description: "rule.archivewhencompleted", ruleType: .onEnd, actionType: .archive, for: userId),
                     RuleModel(id: UUID(), description: "rule.createnewwhencompleted", ruleType: .onEnd, actionType: .createTask, for: userId),
                     RuleModel(id: UUID(), description: "rule.openmailwhenstarted", ruleType: .onStart, actionType: .openMail, for: userId)]
            case 4: [RuleModel(id: UUID(), description: "rule.archivewhencompleted", ruleType: .onEnd, actionType: .archive, for: userId)]
            case 5: [RuleModel(id: UUID(), description: "rule.archivewhencompleted", ruleType: .onEnd, actionType: .archive, for: userId),
                 RuleModel(id: UUID(), description: "rule.createnewwhencompleted", ruleType: .onEnd, actionType: .createTask, for: userId)]
            default: [RuleModel(id: UUID(), description: "rule.archivewhencompleted", ruleType: .onEnd, actionType: .archive, for: userId),
                      RuleModel(id: UUID(), description: "rule.createnewwhencompleted", ruleType: .onEnd, actionType: .createTask, for: userId),
                      RuleModel(id: UUID(), description: "rule.opencalendarwhenstarted", ruleType: .onStart, actionType: .openCalendar, for: userId)]  //0
        }
        return rules
            .compactMap {
                return self.createIfNotExists(description: $0.description, ruleType: $0.ruleType, actionType: $0.actionType, args: $0.args, for: $0.user.id!)
            }
            .flatten(on: database.eventLoop)
    }
    
    public func createDemo(_ exampleNo: Int, taskId: UUID, userId: UUID) -> Future<[RuleModel]> {
        return self
           .getDemo(exampleNo, userId: userId)
           .flatMap { rules in
               rules
                   .map { rule in
                       return TaskRule(id: UUID(), taskId: taskId, ruleId: rule.id!)
                           .create(on: database)
                           .map { return rule }
                   }
                   .flatten(on: database.eventLoop)
           }
    }
}

extension DatabaseTagRepository: TagRepositoryMockProtocol {
    public func getDemo(_ exampleNo: Int, userId: UUID) -> Future<[TagModel]> {
        let names = switch exampleNo {
            case 1: ["tag.soon", "tag.under_progress"]
            case 2: ["tag.someday", "tag.waiting_for","tag.less_10min.", "tag.frequently"]
            default: ["tag.house", "tag.mobile"]
        }
        return names
            .map { name in
                return self
                    .find(userId: userId, description: name)
                    .flatMapThrowing { tagModel in
                        if let _ = tagModel {
                            return tagModel! }
                        throw TagControllerError.missingTag
                    }
            }
            .flatten(on: database.eventLoop)
    }
    
    public func createDemo(_ exampleNo: Int, taskId: UUID, userId: UUID) -> Future<[TagModel]> {
        return self
           .getDemo(exampleNo, userId: userId)
           .flatMap { tags in
               tags
                   .map { tag in
                       return TaskTag(id: UUID(), taskId: taskId, tagId: tag.id!)
                           .create(on: database)
                           .map { return tag }
                   }
                   .flatten(on: database.eventLoop)
           }
    }
}
