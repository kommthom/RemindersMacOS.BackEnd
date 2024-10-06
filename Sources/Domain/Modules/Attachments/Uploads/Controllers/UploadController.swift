//
//  UploadController.swift
//
//
//  Created by Thomas Benninghaus on 01.05.24.
//

import Vapor
import Fluent
import DTO

public struct UploadController: RouteCollection {
    private let useCase = UploadUseCase()
    private let logger = Logger(label: "reminders.backend.uploads")
    
    public func boot(routes: RoutesBuilder) throws {
        routes.grouped("api", "uploads").group(Payload.guardMiddleware()) { upload in
            upload.post("create", use: createUpload)
            upload.post("createmany", use: createUploads)
            upload.post("get", use: getUpload)
            upload.post("getall", use: getUploads)
            upload.post("delete", use: deleteUpload)
        }
    }

    public func createUpload(_ req: Request) -> Future<HTTPStatus> {
        do {
            try UploadDTO.validate(content: req)
            let uploadRequest = try req.content.decode(UploadDTO.self)
            return useCase.createUpload(req, createUploadRequest: uploadRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(UploadControllerError.unableToCreateNewRecord)
        }
    }

    public func createUploads(_ req: Request) -> Future<HTTPStatus> {
        do {
            try UploadsDTO.validate(content: req)
            let uploadsRequest = try req.content.decode(UploadsDTO.self)
            return useCase.createUploads(req, createUploadsRequest: uploadsRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(UploadControllerError.unableToCreateNewRecord)
        }
    }

    public func getUpload(_ req: Request) -> Future<UploadDTO> {
        do {
            let getUploadRequest = try req.content.decode(UUIDRequest.self)
            return useCase
                .getUpload(req, getUploadRequest: getUploadRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(UploadControllerError.idParameterInvalid)
        }
    }

    public func getUploads(_ req: Request) -> Future<UploadsDTO> {
        do {
            let getUploadsRequest = try req.content.decode(UUIDRequest.self)
            return useCase.getUploads(req, getUploadsRequest: getUploadsRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(UploadControllerError.idParameterInvalid)
        }
    }
    
    public func deleteUpload(_ req: Request) -> Future<HTTPStatus> {
        do {
            let deleteUploadRequest = try req.content.decode(UUIDRequest.self)
            return useCase.deleteUpload(req, deleteUploadRequest: deleteUploadRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(UploadControllerError.unableToDeleteRecord)
        }
    }
}

