//
//  LocaleUseCase.swift
//  
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import Fluent
import DTO

public struct LocaleUseCase: LocaleUseCaseProtocol {
    public init() {
    }

    public func createLocale(_ req: Request, createLocaleRequest: LocaleDTO) -> Future<HTTPStatus> {
        return req.locales
            .create(LocaleModel(from: createLocaleRequest))
            .flatMap {
                req.userLocalization.appendNew(createLocaleRequest.name, value: .universal(value: createLocaleRequest.localizedDescription), req: req)
            }
            .transform(to: .created)
    }

    public func getSingleDTO(from model: LocaleModel, localization: @escaping (String) -> String) -> LocaleDTO {
        return LocaleDTO(model: model, localization: localization)
    }
    
    public func getManyDTOs(from models: [LocaleModel], localization: @escaping (String) -> String) -> LocalesDTO {
        return LocalesDTO(many: models, localization: localization)
    }
    
    public func getLocale(_ req: Request, getLocaleRequest: UUIDRequest) -> Future<LocaleDTO> {
        return req.locales
            .find(id: getLocaleRequest.id)
            .unwrap(or: LocaleControllerError.missingLocale)
            .map { locale in
                return getSingleDTO(from: locale, localization: {
                    req.userLocalization.localize($0, interpolations: nil, req: req)
                } )
            }
    }
    
    public func getLocales(_ req: Request) -> Future<LocalesDTO> {
        return req.locales
            .all()
            .flatMapErrorThrowing {
                throw $0
            }
            .map { locales in
                return getManyDTOs(from: locales, localization: {
                    req.userLocalization.localize($0, interpolations: nil, req: req)
                } )
            }
    }
    
    public func updateLocale(_ req: Request, updateLocaleRequest: LocaleDTO) -> Future<HTTPStatus> {
        return req.locales
            .set(LocaleModel(from: updateLocaleRequest))
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }

    public func deleteLocale(_ req: Request, deleteLocaleRequest: UUIDRequest) -> Future<HTTPStatus> {
        return req.locales
            .delete(id: deleteLocaleRequest.id)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }
}
