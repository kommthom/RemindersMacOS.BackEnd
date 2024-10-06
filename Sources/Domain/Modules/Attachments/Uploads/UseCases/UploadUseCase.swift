//
//  UploadUseCase.swift
//  
//
//  Created by Thomas Benninghaus on 01.05.24.
//

import Vapor
import Fluent
import Resources
import DTO

public struct UploadUseCase: UploadUseCaseProtocol {
    public init() {
    }
    
    private func uploadPath(_ req: Request) -> String {
        return req.application.directory.publicDirectory + "uploads/"
    }

    public func createUpload(_ req: Request, createUploadRequest: UploadDTO) -> Future<HTTPStatus> {
        return req.fileio
            .writeFile(createUploadRequest.byteBuffer, at: uploadPath(req) + createUploadRequest.fileName )
            .map {
                let upload = UploadModel(from: createUploadRequest)
                return req.uploads
                    .create(upload)
            }
            .transform(to: .created)
    }

    public func createUploads(_ req: Request, createUploadsRequest: UploadsDTO) -> Future<HTTPStatus> {
        return createUploadsRequest.uploads
            .sequencedFlatMapEach(on: req.eventLoop) { dto in
                createUpload(req, createUploadRequest: dto)
            }
            .transform(to: .created)
    }

    public func getManyDTOs(_ req: Request, from models: [UploadModel]) -> Future<UploadsDTO?> {
        return models
            .sequencedFlatMapEach(on: req.eventLoop) { upload in
                return getSingleDTO(req, from: upload)
                    .map { return $0! }
            }
            .map { dtos in
                return UploadsDTO(uploads: dtos)
            }
    }
    
    public func getSingleDTO(_ req: Request, from model: UploadModel) -> Future<UploadDTO?> {
        var dto: UploadDTO? = nil
        return req.fileio
            .readFile(at: uploadPath(req) + model.fileName) { buffer in
                dto = UploadDTO(model: model, byteBuffer: buffer)!
                return req.eventLoop.makeSucceededVoidFuture()
            }
            .map { return dto }
    }

    public func getUpload(_ req: Request, getUploadRequest: UUIDRequest) -> Future<UploadDTO?> {
        return req.uploads
            .find(id: getUploadRequest.id)
            .unwrap(or: UploadControllerError.missingUpload)
            .flatMap { upload in
                return getSingleDTO(req, from: upload)
            }
    }
    
    public func getUploads(_ req: Request, getUploadsRequest: UUIDRequest) -> Future<UploadsDTO?> {
        return req.uploads
            .all(for: getUploadsRequest.id)
            .flatMap { uploads in
                return getManyDTOs(req, from: uploads)
            }
    }

    public func deleteUpload(_ req: Request, deleteUploadRequest: UUIDRequest) -> Future<HTTPStatus> {
        return req.uploads
            .delete(id: deleteUploadRequest.id)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }
}
