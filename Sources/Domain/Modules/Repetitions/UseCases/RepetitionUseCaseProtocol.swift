//
//  RepetitionUseCaseProtocol.swift
//
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Vapor
import DTO

public protocol RepetitionUseCaseProtocol: UseCaseProtocol {
    func createRepetition(_ req: Request, createRepetitionRequest: RepetitionDTO) -> Future<HTTPStatus>
    func getCreateArguments() -> RepetitionDTO.CreateArguments
    func getSingleDTO(from model: RepetitionModel, args: RepetitionDTO.CreateArguments?) -> RepetitionDTO
    func getManyDTOs(from models: [RepetitionModel], args: RepetitionDTO.CreateArguments?) -> RepetitionsDTO
    func getRepetition(_ req: Request, getRepetitionRequest: UUIDRequest) -> Future<RepetitionDTO>
    func getRepetitions(_ req: Request, getRepetitionsRequest: UUIDRequest) -> Future<RepetitionsDTO>
    func updateRepetition(_ req: Request, updateRepetitionRequest: RepetitionDTO) -> Future<HTTPStatus>
    func deleteRepetition(_ req: Request, deleteRepetitionRequest: UUIDRequest) -> Future<HTTPStatus>
}
