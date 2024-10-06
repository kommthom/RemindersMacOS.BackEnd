//
//  LanguageUseCase.swift
//  
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import Fluent
import DTO

public struct LanguageUseCase: LanguageUseCaseProtocol {
    public init() {
    }
 
    public func createLanguage(_ req: Request, createLanguageRequest: LanguageDTO) -> Future<HTTPStatus> {
        return req.languages
            .create(LanguageModel(from: createLanguageRequest))
            .flatMap {
                req.userLocalization.appendNew(createLanguageRequest.name, value: .universal(value: createLanguageRequest.localizedDescription), req: req)
            }
            .transform(to: .created)
    }

    public func getSingleDTO(from model: LanguageModel, localization: @escaping (String) -> String) -> LanguageDTO {
        return LanguageDTO(model: model, localization: localization)
    }
    
    public func getManyDTOs(from models: [LanguageModel], localization: @escaping (String) -> String) -> LanguagesDTO {
        return LanguagesDTO(many: models, localization: localization)
    }
    
    public func getLanguage(_ req: Request, getLanguageRequest: UUIDRequest) -> Future<LanguageDTO> {
        return req.languages
            .find(id: getLanguageRequest.id)
            .unwrap(or: LanguageControllerError.missingLanguage)
            .map { language in
                return getSingleDTO(from: language, localization: {
                    req.userLocalization.localize($0, interpolations: nil, req: req)
                })
            }
    }
    
    public func getLanguages(_ req: Request) -> Future<LanguagesDTO> {
        return req.languages
            .all()
            .flatMapErrorThrowing {
                throw $0
            }
            .map { languages in
                return getManyDTOs(from: languages, localization: {
                    req.userLocalization.localize($0, interpolations: nil, req: req)
                })
            }
    }
    
    public func updateLanguage(_ req: Request, updateLanguageRequest: LanguageDTO) -> Future<HTTPStatus> {
        return req.languages
            .set(LanguageModel(from: updateLanguageRequest))
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }

    public func deleteLanguage(_ req: Request, deleteLanguageRequest: UUIDRequest) -> Future<HTTPStatus> {
        return req.languages
            .delete(id: deleteLanguageRequest.id)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }
}
