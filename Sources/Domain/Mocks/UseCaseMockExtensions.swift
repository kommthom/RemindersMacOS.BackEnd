//
//  UseCaseMockExtensions.swift
//
//
//  Created by Thomas Benninghaus on 15.04.24.
//

import Foundation
import Vapor
import Fluent
import DTO

extension ProjectUseCase: ProjectUseCaseMockProtocol {
    public func createProjectDemo(_ req: Request) -> Future<HTTPStatus> {
        do {
            let userId = try (getAuthenticatedUser(req)?.id)!
            return req.tags
                .getDemo(0, userId: userId)
                .map { tags in
                    return req.projects
                        .createDemoProjects(userId: userId, defaultTagId: tags.compactMap { $0.id } ) // -> Future<[ProjectModel]>
                        .flatMap { projects in
                            return projects
                                .enumerated()
                                .map { (index, project) in
                                    return req.tasks
                                        .createDemo(index, projectId: project.id!) // -> Future<[(Int, TaskModel)]>
                                            .flatMap { tasks in  //repetitions
                                                 return tasks
                                                     .map { (indexTask, task) in
                                                         return req.timePeriods
                                                             .createDemo(indexTask, userId: userId) { timePeriods in
                                                                 return req.repetitions
                                                                     .createDemo(indexTask, locale: LocaleIdentifier(rawValue: req.locale)!, taskId: task.id!, timePeriods: timePeriods)
                                                                 } //timePeriods
                                                             .flatMap { _ in //attachments
                                                                 return req.attachments
                                                                    .createDemo(indexTask, taskId: task.id!) //Future<[AttachmentModel]>
                                                                    .flatMap { attachments in
                                                                        return attachments
                                                                            .compactMap { attachment in
                                                                                return req.uploads
                                                                                    .createDemo(indexTask, attachmentId: attachment.id!)  //Future<[UploadModel]>
                                                                            } //attachment
                                                                            .flatten(on: req.eventLoop)
                                                                     }
                                                             } //attachments
                                                             .flatMap { _ in //statushistory
                                                                 return req.histories
                                                                     .createDemo(indexTask, taskId: task.id!, userId: userId)
                                                             } //statushistory
                                                             .flatMap { _ in //rules
                                                                 return req.rules
                                                                     .createDemo(indexTask, taskId: task.id!, userId: userId)
                                                             } //rules
                                                             .flatMap { _ in //tags
                                                                 return req.tags
                                                                     .createDemo(indexTask, taskId: task.id!, userId: userId)
                                                             } //tags
                                                     } //task
                                                     .flatten(on: req.eventLoop)
                                            } //tasks
                                } //project
                                .flatten(on: req.eventLoop)
                        } //projects
                } //tags
                .transform(to: .created)
        } catch { return req.eventLoop.makeFailedFuture(ProjectControllerError.unableToCreateNewRecord) }
    }
}
