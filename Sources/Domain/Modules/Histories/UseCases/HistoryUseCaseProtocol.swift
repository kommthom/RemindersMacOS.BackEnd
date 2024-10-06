//
//  HistoryUseCaseProtocol.swift
//
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Vapor
import DTO

public protocol HistoryUseCaseProtocol: UseCaseProtocol {
    func createHistory(_ req: Request, createHistoryRequest: HistoryDTO) -> Future<HTTPStatus>
    func getSingleDTO(from model: HistoryModel) -> HistoryDTO
    func getManyDTOs(from models: [HistoryModel]) -> HistoriesDTO
    func getHistory(_ req: Request, getHistoryRequest: UUIDRequest) -> Future<HistoryDTO>
    func getHistories(_ req: Request, getHistoriesRequest: UUIDRequest) -> Future<HistoriesDTO>
    func updateHistory(_ req: Request, updateHistoryRequest: HistoryDTO) -> Future<HTTPStatus>
    func deleteHistory(_ req: Request, deleteHistoryRequest: UUIDRequest) -> Future<HTTPStatus>
}
