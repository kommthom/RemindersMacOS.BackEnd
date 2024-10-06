//
//  TimePeriodUseCase.swift
//
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Vapor
import Fluent
import Resources
import DTO

public struct TimePeriodUseCase: TimePeriodUseCaseProtocol {
    public init() {
    }
    
    private func getAuthenticatedUser(_ req: Request) throws -> AuthenticatedUser? {
        if let authenticatedUser = req.auth.get(AuthenticatedUser.self) {
            return authenticatedUser
        } else { throw AuthenticationError.userNotFound }
    }
 
    public func createTimePeriod(_ req: Request, createTimePeriodRequest: TimePeriodDTO) -> Future<HTTPStatus> {
        do {
            return req.timePeriods
                .createIfNotExists(typeOfTime: createTimePeriodRequest.typeOfTime, from: createTimePeriodRequest.from, to: createTimePeriodRequest.to, day: createTimePeriodRequest.day, for: (try getAuthenticatedUser(req)?.id)!, repetitionId: nil)
                    .transform(to: .created)
        } catch let error { return req.eventLoop.makeFailedFuture(error) }
    }
        
    public func createTimePeriods(_ req: Request,
                                 createTimePeriodsRequest: TimePeriodsDTO,
                                 createRepetition: @escaping () -> Future<UUID>
                                ) -> Future<HTTPStatus> {
        do {
            let userId = (try getAuthenticatedUser(req)?.id)!
            return createTimePeriodsRequest.timePeriods
                .compactMap { timePeriod in
                    return req.timePeriods
                        .createIfNotExists(typeOfTime: timePeriod.typeOfTime, from: timePeriod.from, to: timePeriod.to, day: timePeriod.day, for: userId, repetitionId: nil)
                }
                .flatten(on: req.eventLoop)
                .flatMap { timePeriods in
                    return createRepetition()
                        .flatMap { repetitionId in
                            return req.timePeriods
                                .createLinks(repetitionId: repetitionId, timePeriods: timePeriods)
                                .map { return timePeriods }
                        }
                }
                .transform(to: .created)
        } catch let error { return req.eventLoop.makeFailedFuture(error) }
    }

    public func getSingleDTO(from model: TimePeriodModel) -> TimePeriodDTO {
        TimePeriodDTO(model: model)
    }
    
    public func getManyDTOs(from models: [TimePeriodModel]) -> TimePeriodsDTO {
        TimePeriodsDTO(many: models)
    }
    
    public func getTimePeriod(_ req: Request, getTimePeriodRequest: UUIDRequest) -> Future<TimePeriodDTO> {
        return req.timePeriods
            .find(id: getTimePeriodRequest.id)
            .unwrap(or: TimePeriodControllerError.missingTimePeriod)
            .map { timePeriod in
                return getSingleDTO(from: timePeriod)
            }
    }
    
    public func getTimePeriods(_ req: Request) -> Future<TimePeriodsDTO> {
        do {
            return req.timePeriods
                .all(userId: (try getAuthenticatedUser(req)?.id)!)
                .map { timePeriods in
                    return getManyDTOs(from: timePeriods)
                }
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func updateTimePeriod(_ req: Request, updateTimePeriodRequest: TimePeriodDTO) -> Future<HTTPStatus> {
        do {
            let timePeriod = TimePeriodModel(from: updateTimePeriodRequest, for: (try getAuthenticatedUser(req)?.id)!)
            return req.timePeriods
                .set(timePeriod)
                .flatMapErrorThrowing {
                    throw $0
                }
                .transform(to: .noContent)
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }

    public func deleteTimePeriod(_ req: Request, deleteTimePeriodRequest: UUIDRequest) -> Future<HTTPStatus> {
        return req.timePeriods
            .delete(id: deleteTimePeriodRequest.id, force: false)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }
    
    public func getTimePeriodsWithSelection(_ req: Request, allWithSelectionRequest: UUIDRequest) -> Future<TimePeriodSelectionsDTO> {
        do {
            return req.timePeriods
                .allWithSelection(userId: (try getAuthenticatedUser(req)?.id)!, taskId: allWithSelectionRequest.id)
                .map { timePeriods in
                    return TimePeriodSelectionsDTO(for: allWithSelectionRequest.id, many: timePeriods)
                }
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func updateSelection(_ req: Request, setSelectionRequest: TimePeriodSelectionsDTO) -> Future<HTTPStatus> {
        do {
            let taskId: UUID? = setSelectionRequest.taskId
            let timePeriodIds: [UUID] = setSelectionRequest
                .timePeriodSelections
                .compactMap { timePeriodSelection in
                    if timePeriodSelection.isSelected {
                        return timePeriodSelection.timePeriod.id
                    }
                    return nil
                }
            return req.timePeriods
                .setSelection(userId: (try getAuthenticatedUser(req)?.id)!, taskId: taskId, timePeriodIds: timePeriodIds)
                .flatMapErrorThrowing {
                    throw $0
                }
                .transform(to: .noContent)
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
}
