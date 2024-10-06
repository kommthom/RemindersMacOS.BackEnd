//
//  HistoryUseCase.swift
//
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Vapor
import Fluent
import Resources
import DTO

public struct HistoryUseCase: HistoryUseCaseProtocol {
    public init() {
    }
    
    public func createHistory(_ req: Request, createHistoryRequest: HistoryDTO) -> Future<HTTPStatus> {
        let history = HistoryModel(from: createHistoryRequest)
        return req.histories
            .create(history)
            .transform(to: .created)
    }

    public func getSingleDTO(from model: HistoryModel) -> HistoryDTO {
        return HistoryDTO(model: model)
    }
    
    public func getManyDTOs(from models: [HistoryModel]) -> HistoriesDTO {
        return HistoriesDTO(many: models)
    }
    
    public func getHistory(_ req: Request, getHistoryRequest: UUIDRequest) -> Future<HistoryDTO> {
        return req.histories
            .find(id: getHistoryRequest.id)
            .unwrap(or: HistoryControllerError.missingHistory)
            .map { history in
                return getSingleDTO(from: history)
            }
    }
    
    public func getHistories(_ req: Request, getHistoriesRequest: UUIDRequest) -> Future<HistoriesDTO> {
        return req.histories
            .all(for: getHistoriesRequest.id)
            .map { histories in
                return getManyDTOs(from: histories)
            }
    }
    
    public func updateHistory(_ req: Request, updateHistoryRequest: HistoryDTO) -> Future<HTTPStatus> {
        let history = HistoryModel(from: updateHistoryRequest)
        return req.histories
            .set(history)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }

    public func deleteHistory(_ req: Request, deleteHistoryRequest: UUIDRequest) -> Future<HTTPStatus> {
        return req.histories
            .delete(id: deleteHistoryRequest.id)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }
}
