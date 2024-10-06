//
//  TimePeriodUseCaseProtocol.swift
//
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Vapor
import DTO

public protocol TimePeriodUseCaseProtocol: UseCaseProtocol {
    func createTimePeriod(_ req: Request, createTimePeriodRequest: TimePeriodDTO) -> Future<HTTPStatus>
    func createTimePeriods(_ req: Request, createTimePeriodsRequest: TimePeriodsDTO, createRepetition: @escaping () -> Future<UUID> ) -> Future<HTTPStatus>
    func getSingleDTO(from model: TimePeriodModel) -> TimePeriodDTO
    func getManyDTOs(from models: [TimePeriodModel]) -> TimePeriodsDTO
    func getTimePeriod(_ req: Request, getTimePeriodRequest: UUIDRequest) -> Future<TimePeriodDTO>
    func getTimePeriods(_ req: Request) -> Future<TimePeriodsDTO>
    func updateTimePeriod(_ req: Request, updateTimePeriodRequest: TimePeriodDTO) -> Future<HTTPStatus>
    func deleteTimePeriod(_ req: Request, deleteTimePeriodRequest: UUIDRequest) -> Future<HTTPStatus>
    func getTimePeriodsWithSelection(_ req: Request, allWithSelectionRequest: UUIDRequest) -> Future<TimePeriodSelectionsDTO>
    func updateSelection(_ req: Request, setSelectionRequest: TimePeriodSelectionsDTO) -> Future<HTTPStatus>
}
