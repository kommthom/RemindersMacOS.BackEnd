//
//  LanguageUseCaseProtocol.swift
//  
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import DTO

public protocol LanguageUseCaseProtocol: UseCaseProtocol {
    func createLanguage(_ req: Request, createLanguageRequest: LanguageDTO) -> Future<HTTPStatus>
    func getSingleDTO(from model: LanguageModel, localization: @escaping (String) -> String) -> LanguageDTO
    func getManyDTOs(from models: [LanguageModel], localization: @escaping (String) -> String) -> LanguagesDTO
    func getLanguage(_ req: Request, getLanguageRequest: UUIDRequest) -> Future<LanguageDTO>
    func getLanguages(_ req: Request) -> Future<LanguagesDTO>
    func updateLanguage(_ req: Request, updateLanguageRequest: LanguageDTO) -> Future<HTTPStatus>
    func deleteLanguage(_ req: Request, deleteLanguageRequest: UUIDRequest) -> Future<HTTPStatus>
}
