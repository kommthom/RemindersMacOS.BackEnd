//
//  LocalizationUseCase.swift
//
//
//  Created by Thomas Benninghaus on 14.05.24.
//

import Vapor
import Fluent
import DTO

public struct LocalizationUseCase: LocalizationUseCaseProtocol {
    public init() {
    }

    public func createLocalization(_ req: Request, createLocalizationRequest: LocalizationDTO) -> Future<HTTPStatus> {
        return req.localizations
                .create(LocalizationModel(from: createLocalizationRequest))
                .transform(to: .created)
    }

    public func getSingleDTO(from model: LocalizationModel) -> LocalizationDTO {
        return LocalizationDTO(model: model)
    }
    
    public func getManyDTOs(from models: [LocalizationModel]) -> LocalizationsDTO {
        return LocalizationsDTO(many: models)
    }
    
    public func getLocalization(_ req: Request, getLocalizationRequest: UUIDRequest) -> Future<LocalizationDTO> {
        return req.localizations
            .find(id: getLocalizationRequest.id)
            .unwrap(or: LocalizationControllerError.missingLocalization)
            .map { localization in
                return getSingleDTO(from: localization)
            }
    }
    
    public func getLocalizations(_ req: Request) -> Future<LocalizationsDTO> {
        return req.localizations
            .all()
            .flatMapErrorThrowing { throw $0 }
            .map { localizations in
                return getManyDTOs(from: localizations)
            }
    }
    
    public func updateLocalization(_ req: Request, updateLocalizationRequest: LocalizationDTO) -> Future<HTTPStatus> {
        let localization = LocalizationModel(from: updateLocalizationRequest)
        return req.localizations
            .set(localization)
            .flatMapErrorThrowing { throw $0 }
            .transform(to: .noContent)
    }

    public func deleteLocalization(_ req: Request, deleteLocalizationRequest: UUIDRequest) -> Future<HTTPStatus> {
        return req.localizations
            .delete(id: deleteLocalizationRequest.id, force: false)
            .flatMapErrorThrowing { throw $0 }
            .transform(to: .noContent)
    }
}

