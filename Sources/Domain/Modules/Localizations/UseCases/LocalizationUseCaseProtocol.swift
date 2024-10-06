//
//  LocalizationUseCaseProtocol.swift
//  
//
//  Created by Thomas Benninghaus on 14.05.24.
//

import Vapor
import DTO

public protocol LocalizationUseCaseProtocol: UseCaseProtocol {
    func createLocalization(_ req: Request, createLocalizationRequest: LocalizationDTO) -> Future<HTTPStatus>
    func getSingleDTO(from model: LocalizationModel) -> LocalizationDTO
    func getManyDTOs(from models: [LocalizationModel]) -> LocalizationsDTO
    func getLocalization(_ req: Request, getLocalizationRequest: UUIDRequest) -> Future<LocalizationDTO>
    func getLocalizations(_ req: Request) -> Future<LocalizationsDTO>
    func updateLocalization(_ req: Request, updateLocalizationRequest: LocalizationDTO) -> Future<HTTPStatus>
    func deleteLocalization(_ req: Request, deleteLocalizationRequest: UUIDRequest) -> Future<HTTPStatus>
}
