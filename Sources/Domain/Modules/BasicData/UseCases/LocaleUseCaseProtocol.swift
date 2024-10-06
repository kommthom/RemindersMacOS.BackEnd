//
//  LocaleUseCaseProtocol.swift
//  
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import DTO

public protocol LocaleUseCaseProtocol: UseCaseProtocol {
    func createLocale(_ req: Request, createLocaleRequest: LocaleDTO) -> Future<HTTPStatus>
    func getSingleDTO(from model: LocaleModel, localization: @escaping (String) -> String) -> LocaleDTO
    func getManyDTOs(from models: [LocaleModel], localization: @escaping (String) -> String) -> LocalesDTO
    func getLocale(_ req: Request, getLocaleRequest: UUIDRequest) -> Future<LocaleDTO>
    func getLocales(_ req: Request) -> Future<LocalesDTO>
    func updateLocale(_ req: Request, updateLocaleRequest: LocaleDTO) -> Future<HTTPStatus>
    func deleteLocale(_ req: Request, deleteLocaleRequest: UUIDRequest) -> Future<HTTPStatus>
}
