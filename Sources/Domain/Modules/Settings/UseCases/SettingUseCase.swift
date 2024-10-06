//
//  SettingUseCase.swift
//  
//
//  Created by Thomas Benninghaus on 01.02.24.
//

import Vapor
import Fluent
import Resources
import DTO

/// Use cases for Users
public struct SettingUseCase: SettingUseCaseProtocol {
    
    /// Default initializer.
    public init() {
        
    }
    
    private func getAuthenticatedUser(_ req: Request) throws -> AuthenticatedUser? {
        if let authenticatedUser = req.auth.get(AuthenticatedUser.self) {
            return authenticatedUser
        } else {
            throw AuthenticationError.userNotFound
        }
    }
    
    private func translateSetting(localization: LocalizationProtocol, language: LanguageIdentifier, setting: SettingModel) -> SettingModel {
        let description = localization.localize(setting.name, locale: language.code, interpolations: nil)
        if !description.isEmpty {
            let newSetting = setting
            newSetting.description = description
            return newSetting
        } else {
            return setting
        }
    }
    
    public func createSetting(_ req: Request, createSettingRequest: SettingDTO) -> Future<HTTPStatus> {
        do {
            if let authenticatedUser = try getAuthenticatedUser(req) {
                let setting = SettingModel(from: createSettingRequest, for: authenticatedUser.id)
                return req.settings
                    .create(setting)
                    .transform(to: .created)
            } else {
                return req.eventLoop.makeFailedFuture(AuthenticationError.userNotFound)
            }
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }

    public func getSetting(_ req: Request, getSettingRequest: UUIDRequest) -> Future<SettingDTO> {
        do {
            let localization = req.userLocalization
            let authenticatedUser = try getAuthenticatedUser(req)
            return req.settings
                .find(id: getSettingRequest.id)
                .unwrap(or: SettingControllerError.missingSetting)
                .map { setting in
                    SettingDTO(model: translateSetting(localization: localization, language: authenticatedUser!.locale.language, setting: setting))
                }
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func getSettings(_ req: Request) -> Future<SettingsDTO> {
        do {
            let localization = req.userLocalization
            let authenticatedUser = try getAuthenticatedUser(req)
            return req.settings
                .all(userId: authenticatedUser?.id)
                .flatMapEachThrowing { setting in
                    translateSetting(localization: localization, language: authenticatedUser!.locale.language, setting: setting)
                }
                .map { settings in
                    return SettingsDTO(many: settings)
                }
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func getSettingsByScope(_ req: Request, getSettingsRequest: GetSettingsRequest) -> Future<SettingsDTO> {
        do {
            let localization = req.userLocalization
            let authenticatedUser = try getAuthenticatedUser(req)
            return req.settings
                .all(userId: authenticatedUser?.id, type: getSettingsRequest.scope)
                .flatMapEachThrowing { setting in
                    translateSetting(localization: localization, language: authenticatedUser!.locale.language, setting: setting)
                }
                .map { settings in
                    return SettingsDTO(many: settings)
                }
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func getSidebar(_ req: Request) -> Future<SettingsDTO> {
        do {
            let localization = req.userLocalization
            let authenticatedUser = try getAuthenticatedUser(req)
            return req.settings
                .sidebar(userId: authenticatedUser?.id)
                .flatMapEachThrowing { setting in
                    translateSetting(localization: localization, language: authenticatedUser!.locale.language, setting: setting)
                }
                .map { settings in
                    return SettingsDTO(many: settings)
                }
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func updateSetting(_ req: Request, updateSettingRequest: SettingDTO) -> Future<HTTPStatus> {
        do {
            let setting = SettingModel(from: updateSettingRequest, for: try getAuthenticatedUser(req)!.id)
            return req.settings
                .set(setting)
                .flatMapErrorThrowing {
                    throw $0
                }
                .transform(to: .noContent)
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }

    public func deleteSetting(_ req: Request, deleteSettingRequest: UUIDRequest) -> Future<HTTPStatus> {
        return req.settings
            .delete(id: deleteSettingRequest.id, force: false)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }
}
