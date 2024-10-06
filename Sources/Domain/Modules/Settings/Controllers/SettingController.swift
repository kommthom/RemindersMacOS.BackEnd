//
//  SettingController.swift
//
//
//  Created by Thomas Benninghaus on 02.02.24.
//

import Vapor
import Fluent
import DTO

/// Controller For Setting processing
public struct SettingController: RouteCollection {
    private let useCase = SettingUseCase()
    private let logger = Logger(label: "reminders.backend.settings")
    
    public func boot(routes: RoutesBuilder) throws {
        routes.grouped("api", "settings").group(Payload.guardMiddleware()) { setting in
            setting.post("create", use: createSetting)
            setting.post("get", use: getSetting)
            setting.post("getall", use: getSettings)
            setting.post("getbyscope", use: getSettingsByScope)
            setting.post("getsidebar", use: getSidebar)
            setting.post("update", use: updateSetting)
            setting.post("delete", use: deleteSetting)
        }
        routes.grouped("settings").grouped(UserSessionAuthenticator()).group(AuthenticatedUser.guardMiddleware()) { setting in
            //show Html
            setting.get("index", use: index)
            setting.get("add", use: add)
            setting.post("save", use: save)
            setting.get("show", use: show)
            setting.post("update", use: update)
            setting.post("delete", use: delete)
        }
    }

    public func createSetting(_ req: Request) -> Future<HTTPStatus> {
        do {
            try SettingDTO.validate(content: req)
            let settingRequest = try req.content.decode(SettingDTO.self)
            return useCase.createSetting(req, createSettingRequest: settingRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(SettingControllerError.unableToCreateNewRecord)
        }
    }

    public func getSetting(_ req: Request) -> Future<SettingDTO> {
        do {
            let getSettingRequest = try req.content.decode(UUIDRequest.self)
            return useCase.getSetting(req, getSettingRequest: getSettingRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(SettingControllerError.idParameterInvalid)
        }
    }

    public func getSettings(_ req: Request) -> Future<SettingsDTO> {
        return useCase.getSettings(req)
    }
    
    public func getSettingsByScope(req: Request) -> Future<SettingsDTO> {
        do {
            let getSettingsRequest = try req.content.decode(GetSettingsRequest.self)
            return useCase.getSettingsByScope(req, getSettingsRequest: getSettingsRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(SettingControllerError.idParameterInvalid)
        }
    }
    
    public func getSidebar(_ req: Request) -> Future<SettingsDTO> {
        return useCase.getSidebar(req)
    }

    public func updateSetting(_ req: Request) -> Future<HTTPStatus> {
        do {
            try SettingDTO.validate(content: req)
            let setting = try req.content.decode(SettingDTO.self)
            return useCase.updateSetting(req, updateSettingRequest: setting)
        } catch {
            return req.eventLoop.makeFailedFuture(SettingControllerError.unableToUpdateRecord)
        }
    }
    
    public func deleteSetting(_ req: Request) -> Future<HTTPStatus> {
        do {
            let deleteSettingRequest = try req.content.decode(UUIDRequest.self)
            return useCase.deleteSetting(req, deleteSettingRequest: deleteSettingRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(SettingControllerError.unableToDeleteRecord)
        }
    }
    
    public func index(req: Request) -> Future<Response> {
        return useCase.getSettings(req)
            .map() { settings in
                req.templates.renderHtml(SettingIndexTemplate(settings))
            }
    }

    public func show(req: Request) -> Future<Response> {
        do {
            let getSettingRequest = try req.content.decode(UUIDRequest.self)
            return showSetting(req, getSettingRequest.id)
        } catch {
            return req.eventLoop.makeFailedFuture(SettingControllerError.idParameterMissing)
        }
    }

    private func showSetting(_ req: Request, _ settingId: UUID) -> Future<Response> {
        return getSetting(req)
            .map() { setting in
                req.templates.renderHtml(SettingShowTemplate(setting))
            }
    }
    
    public func add(req: Request) -> Response {
        return req.templates.renderHtml(SettingAddTemplate())
    }

    public func save(req: Request)  -> Future<Response> {
        return createSetting(req)
            .map { status in
                return req.redirect(to: "/settings/index")
            }
    }

    public func update(req: Request) -> Future<Response> {
        return updateSetting(req)
            .map { status in
                return req.redirect(to: "/settings/index")
            }
    }

    public func delete(req: Request) -> Future<Response> {
        return deleteSetting(req)
            .map { status in
                return req.redirect(to: "/settings/index")
            }
    }
}
