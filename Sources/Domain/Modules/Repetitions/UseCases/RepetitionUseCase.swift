//
//  RepetitionUseCase.swift
//  
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Vapor
import Fluent
import Resources
import DTO

public struct RepetitionUseCase: RepetitionUseCaseProtocol {
    
    public init() {
    }
    
    public func createRepetition(_ req: Request, createRepetitionRequest: RepetitionDTO) -> Future<HTTPStatus> {
        let repetition = RepetitionModel(from: createRepetitionRequest)
        return req.repetitions
            .create(repetition)
            .transform(to: .created)
    }

    public func getCreateArguments() -> RepetitionDTO.CreateArguments {
        return RepetitionDTO.CreateArguments(
            createTimePeriods: TimePeriodUseCase().getManyDTOs
            )
    }
    
    public func getSingleDTO(from model: RepetitionModel, args: RepetitionDTO.CreateArguments? = nil) -> RepetitionDTO {
        return RepetitionDTO(model: model, args: args)
    }
    
    public func getManyDTOs(from models: [RepetitionModel], args: RepetitionDTO.CreateArguments? = nil) -> RepetitionsDTO {
        return RepetitionsDTO(many: models, args: args)
    }
    
    public func getRepetition(_ req: Request, getRepetitionRequest: UUIDRequest) -> Future<RepetitionDTO> {
        return req.repetitions
            .find(id: getRepetitionRequest.id)
            .unwrap(or: RepetitionControllerError.missingRepetition)
            .map { repetition in
                return getSingleDTO(from: repetition, args: getCreateArguments())
            }
    }
    
    public func getRepetitions(_ req: Request, getRepetitionsRequest: UUIDRequest) -> Future<RepetitionsDTO> {
        return req.repetitions
            .all(for: getRepetitionsRequest.id)
            .map { repetitions in
                return getManyDTOs(from: repetitions, args: getCreateArguments())
            }
    }
    
    public func updateRepetition(_ req: Request, updateRepetitionRequest: RepetitionDTO) -> Future<HTTPStatus> {
        let repetition = RepetitionModel(from: updateRepetitionRequest)
        return req.repetitions
            .set(repetition)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }

    public func deleteRepetition(_ req: Request, deleteRepetitionRequest: UUIDRequest) -> Future<HTTPStatus> {
        return req.repetitions
            .delete(id: deleteRepetitionRequest.id)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }
}
