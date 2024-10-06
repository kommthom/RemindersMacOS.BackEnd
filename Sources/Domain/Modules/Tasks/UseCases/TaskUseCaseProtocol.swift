//
//  TaskUseCaseProtocol.swift
//
//
//  Created by Thomas Benninghaus on 27.12.23.
//

import Vapor
import DTO

public protocol TaskUseCaseProtocol: UseCaseProtocol {
    func createTask(_ req: Request, createTaskRequest: TaskDTO) -> Future<HTTPStatus>
    func getCreateArguments(_ req: Request) -> TaskDTO.CreateArguments
    func getSingleDTO(_ req: Request, from model: TaskModel, args: TaskDTO.CreateArguments?) -> Future<TaskDTO?>
    func getManyDTOs(_ req: Request, from models: [TaskModel], args: TaskDTO.CreateArguments?) -> Future<TasksDTO?>
    func getSingleGroupDTO(_ req: Request, from models: [TaskModel], args: TaskDTO.CreateArguments?, groupName: String) -> Future<TaskGroupDTO?>
    func getManyGroupsDTO(_ req: Request, from models: [TaskModel], args: TaskDTO.CreateArguments?, appendTo: Future<TaskGroupsDTO?>?, makeGroupName: @escaping (Date?) -> String) -> Future<TaskGroupsDTO?>
    func getTask(_ req: Request, getTaskRequest: UUIDRequest) -> EventLoopFuture<TaskDTO?>
    func getTasks(_ req: Request, getTasksRequest: UUIDRequest) -> EventLoopFuture<TasksDTO?>
    func getTasksForToday(_ req: Request) -> EventLoopFuture<TaskGroupsDTO?>
    func getTasksSoon(_ req: Request) -> EventLoopFuture<TaskGroupsDTO?>
    func getTasksForTags(_ req: Request, getTasksForTagsRequest: UUIDArrayRequest) -> EventLoopFuture<TaskGroupsDTO?>
    func updateTask(_ req: Request, updateTaskRequest: TaskDTO) -> EventLoopFuture<HTTPStatus>
    func setCompleted(_ req: Request, setTaskCompletedRequest: UUIDRequest) -> Future<HTTPStatus>
    func deleteTask(_ req: Request, deleteTaskRequest: UUIDRequest) -> EventLoopFuture<HTTPStatus>
}
