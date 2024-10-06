//
//  TaskUseCase.swift
//  
//
//  Created by Thomas Benninghaus on 24.12.23.
//

import Vapor
import Fluent
import Resources
import DTO

/// Use cases for Tasks
public struct TaskUseCase: TaskUseCaseProtocol {
    /// Default initializer.
    public init() {}
    
    private func getAuthenticatedUser(_ req: Request) throws -> AuthenticatedUser? {
        if let authenticatedUser = req.auth.get(AuthenticatedUser.self) {
            return authenticatedUser
        } else {
            throw AuthenticationError.userNotFound
        }
    }
    
    private func translateGroupName(localization: LocalizationProtocol, locale: LocaleIdentifier, groupDate: Date?) -> String {
        if let _ = groupDate {
            let formattedDate: String = locale.formatDate(groupDate!)
            let weekDay: String = locale.weekDay(groupDate!)
            if groupDate == Date.today {
                let day = localization.localize("tasks.today", locale: locale.locale.identifier, interpolations: nil)
                return "\(formattedDate)‧\(day)‧\(weekDay)"
            } else if groupDate == Date.tomorrow {
                let day = localization.localize("tasks.tomorrow", locale: locale.locale.identifier, interpolations: nil)
                return "\(formattedDate)‧\(day)‧\(weekDay)"
            } else {
                return "\(formattedDate)‧\(weekDay)"
            }
        } else {
            return localization.localize("tasks.overdue", locale: locale.locale.identifier, interpolations: nil)
        }
    }
    
    public func createTask(_ req: Request, createTaskRequest: TaskDTO) -> Future<HTTPStatus> {
        do {
            let authenticatedUser = try getAuthenticatedUser(req)
            
            return req.tasks
                .create(TaskModel(from: createTaskRequest, for: (authenticatedUser?.id)!))
                .flatMap { //task
                    if let repetitionDTO = createTaskRequest.repetition {
                        if repetitionDTO.timePeriods?.timePeriods.count ?? 0 > 0 {
                            return TimePeriodUseCase()
                                .createTimePeriods(req, createTimePeriodsRequest: repetitionDTO.timePeriods!) {
                                    return RepetitionUseCase()
                                        .createRepetition(req, createRepetitionRequest: repetitionDTO)
                                        .map { _ in return repetitionDTO.id! }
                                } //createRepetition -> Future<HTTPStatus>
                                .transform(to: HTTPStatus.created)
                        } // no timePeriods
                        return RepetitionUseCase()
                            .createRepetition(req, createRepetitionRequest: repetitionDTO)
                    }
                    return req.eventLoop.makeSucceededFuture(.created)
                } //task
                .flatMap { _ in //HTTPStatus/task
                    if let attachments = createTaskRequest.attachments {
                        if attachments.attachments.count > 0 {
                            return attachments.attachments
                                .compactMap { attachmentDTO in
                                    return AttachmentUseCase()
                                        .createAttachment(req, createAttachmentRequest: attachmentDTO)
                                        .map { _ in
                                            if let uploads = attachmentDTO.files {
                                                return UploadUseCase()
                                                    .createUploads(req, createUploadsRequest: uploads)
                                            }
                                            return req.eventLoop.makeSucceededFuture(.created)
                                        }
                                } //attachments
                                .flatten(on: req.eventLoop)
                                .transform(to: HTTPStatus.created)
                        }
                    }
                    return req.eventLoop.makeSucceededFuture(HTTPStatus.created)
                } //HTTPStatus/task
                .flatMap { _ in //HTTPStatus/task
                    return HistoryUseCase()
                        .createHistory(req, createHistoryRequest: HistoryDTO(id: UUID(), historyType: .create, taskId: createTaskRequest.id!))
                } //HTTPStatus/task
                .flatMap { _ in //HTTPStatus/task
                    if let rules = createTaskRequest.rules {
                        if rules.rules.count > 0 {
                            return rules.rules
                                .compactMap { ruleDTO in
                                    return RuleUseCase()
                                        .createRule(req, createRuleRequest: ruleDTO, taskId: createTaskRequest.id)
                                }
                            .flatten(on: req.eventLoop)
                            .transform(to: HTTPStatus.created)
                        } //rules
                    }
                    return req.eventLoop.makeSucceededFuture(HTTPStatus.created)
                } //HTTPStatus/task
                .flatMap { _ in //HTTPStatus/task
                    if let tags = createTaskRequest.tags {
                        if tags.tags.count > 0 {
                            return tags.tags
                                .compactMap { tagDTO in
                                    return TagUseCase()
                                        .createTag(req, createTagRequest: tagDTO, taskId: createTaskRequest.id)
                                }
                            .flatten(on: req.eventLoop)
                            .transform(to: HTTPStatus.created)
                        } //tags
                    }
                    return req.eventLoop.makeSucceededFuture(HTTPStatus.created)
                } //HTTPStatus/task
                .transform(to: .created)
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func getCreateArguments(_ req: Request) -> TaskDTO.CreateArguments {
        return TaskDTO.CreateArguments(
            createAttachments: AttachmentUseCase().getManyDTOs,
            createRepetition: RepetitionUseCase().getSingleDTO,
            createChildren: getManyDTOs,
            createHistories: HistoryUseCase().getManyDTOs,
            createRules: RuleUseCase().getManyDTOs,
            createTags: TagUseCase().getManyDTOs,
            createAttachmentsArgs: AttachmentUseCase().getCreateArguments(req),
            createRepetitionArgs: RepetitionUseCase().getCreateArguments())
    }
    
    public func getSingleDTO(_ req: Request, from model: TaskModel, args: TaskDTO.CreateArguments?) -> Future<TaskDTO?> {
        return TaskDTO
            .futureInit(req, model: model, args: args)
            .map { $0 }
    }
    
    public func getManyDTOs(_ req: Request, from models: [TaskModel], args: TaskDTO.CreateArguments?) -> Future<TasksDTO?> {
        return TasksDTO
            .futureInit(req, many: models, args:  args)
    }
    
    public func getSingleGroupDTO(_ req: Request, from models: [TaskModel], args: TaskDTO.CreateArguments?, groupName: String) -> Future<TaskGroupDTO?> {
        return TaskGroupDTO
            .futureInit(req, groupName: groupName, groupDate: nil, many: models, args: args)
            .map { $0 }
    }
    
    public func getManyGroupsDTO(_ req: Request, from models: [TaskModel], args: TaskDTO.CreateArguments?, appendTo: Future<TaskGroupsDTO?>? = nil, makeGroupName: @escaping (Date?) -> String) -> Future<TaskGroupsDTO?> {
        return TaskGroupsDTO
            .futureInit(req, appendTo: appendTo, many: models, args: getCreateArguments(req), makeGroupName: { makeGroupName($0) })
            .map { $0 }
    }

    public func getTask(_ req: Request, getTaskRequest: UUIDRequest) -> Future<TaskDTO?> {
        return req.tasks
            .find(id: getTaskRequest.id)
            .unwrap(or: TaskControllerError.missingTask)
            .flatMap { model in
                return getSingleDTO(req, from: model, args: getCreateArguments(req))
            }
    }
    
    public func getTasks(_ req: Request, getTasksRequest: UUIDRequest) -> EventLoopFuture<TasksDTO?> {
        return req.tasks
            .all(for: getTasksRequest.id)
            .flatMap { tasks in
                return getManyDTOs(req, from: tasks, args: getCreateArguments(req))
            }
    }
    
    public func getTasksForToday(_ req: Request) -> EventLoopFuture<TaskGroupsDTO?> {
        if let translator = try? GroupNameTranslator(req: req) {
            return req.tasks
                .overdue(userId: translator.authenticatedUser.id)
                .map { tasks in
                    return getManyGroupsDTO(req, from: tasks, args: getCreateArguments(req), makeGroupName: translator.fromDate)
                }
                .flatMap { groups in
                    return req.tasks
                        .today(userId: translator.authenticatedUser.id)
                        .flatMap { tasks in
                            return getManyGroupsDTO(req, from: tasks, args: getCreateArguments(req), appendTo: groups, makeGroupName: translator.fromDate)
                                .map { $0! }
                        }
                }
        } else { return req.eventLoop.makeFailedFuture(TaskControllerError.idParameterInvalid) }
    }
    
    public func getTasksSoon(_ req: Request) -> EventLoopFuture<TaskGroupsDTO?> {
        if let translator = try? GroupNameTranslator(req: req) {
            return req.tasks
                .overdue(userId: translator.authenticatedUser.id)
                .map { tasks in
                    return getManyGroupsDTO(req, from: tasks, args: getCreateArguments(req), makeGroupName: translator.fromDate)
                }
                .flatMap { groups in
                    return req.tasks
                        .soon(userId: translator.authenticatedUser.id)
                        .flatMap { tasks in
                            return getManyGroupsDTO(req, from: tasks, args: getCreateArguments(req), appendTo: groups, makeGroupName: translator.fromDate)
                                .map { $0! }
                        }
                }
        } else { return req.eventLoop.makeFailedFuture(TaskControllerError.idParameterInvalid) }
    }
    
    public func getTasksForTags(_ req: Request, getTasksForTagsRequest: UUIDArrayRequest) -> EventLoopFuture<TaskGroupsDTO?> {
        if let translator = try? GroupNameTranslator(req: req) {
            return getTasksForTagsRequest.ids
                .map { id in
                    req.tags
                        .find(id: id)
                        .flatMap { tag in
                            let groupName = translator.fromString(groupName: (tag?.description)!)
                            return req.tasks
                                .byTag(tagId: (tag?.id)!)
                                .flatMap { tasks in
                                    return getSingleGroupDTO(req, from: tasks, args: getCreateArguments(req), groupName: groupName)
                                        .map { $0! }
                                }
                        }
                }
                .flatten(on: req.eventLoop)
                .map { TaskGroupsDTO(many: $0) }
        } else { return req.eventLoop.makeFailedFuture(TaskControllerError.idParameterInvalid) }
    }
    
    public func updateTask(_ req: Request, updateTaskRequest: TaskDTO) -> EventLoopFuture<HTTPStatus> {
        do {
            let authenticatedUser = try getAuthenticatedUser(req)
            return req.tasks
                .set(TaskModel(from: updateTaskRequest, for: (authenticatedUser?.id)!))
                .flatMapErrorThrowing {
                    throw $0
                }
                .transform(to: .noContent)
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }

    public func setCompleted(_ req: Request, setTaskCompletedRequest: UUIDRequest) -> Future<HTTPStatus> {
        do {
            let authenticatedUser = try getAuthenticatedUser(req)
            return req.tasks
                .setCompleted(setTaskCompletedRequest.id, userId: (authenticatedUser?.id)!)
                .flatMapErrorThrowing {
                    throw $0
                }
                .transform(to: .noContent)
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func deleteTask(_ req: Request, deleteTaskRequest: UUIDRequest) -> EventLoopFuture<HTTPStatus> {
        return req.tasks
            .delete(id: deleteTaskRequest.id, force: false)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }
}

