//
//  AttachmentUseCase.swift
//
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Vapor
import Fluent
import Resources
import DTO

public struct AttachmentUseCase: AttachmentUseCaseProtocol {
    public init() {
    }
    
    public func createAttachment(_ req: Request, createAttachmentRequest: AttachmentDTO) -> Future<HTTPStatus> {
        let attachment = AttachmentModel(from: createAttachmentRequest)
        return req.attachments
            .create(attachment)
            .transform(to: .created)
    }

    public func getCreateArguments(_ req: Request) -> AttachmentDTO.CreateArguments {
        return AttachmentDTO.CreateArguments(createUploads: UploadUseCase().getManyDTOs)
    }
    
    public func getSingleDTO(_ req: Request, from model: AttachmentModel, args: AttachmentDTO.CreateArguments) -> Future<AttachmentDTO?> {
        return AttachmentDTO.futureInit(req, model: model, args: args)
    }
    
    public func getManyDTOs(_ req: Request, from models: [AttachmentModel], args: AttachmentDTO.CreateArguments? = nil) -> Future<AttachmentsDTO?> {
        return AttachmentsDTO.futureInit(req, many: models, args: args)
    }
    
    public func getAttachment(_ req: Request, getAttachmentRequest: UUIDRequest) -> Future<AttachmentDTO?> {
        return req.attachments
            .find(id: getAttachmentRequest.id)
            .unwrap(or: AttachmentControllerError.missingAttachment)
            .flatMap { attachment in
                return getSingleDTO(req, from: attachment, args: getCreateArguments(req))
            }
    }
    
    public func getAttachments(_ req: Request, getAttachmentsRequest: UUIDRequest) -> Future<AttachmentsDTO?> {
        return req.attachments
            .all(for: getAttachmentsRequest.id)
            .flatMap { attachments in
                return getManyDTOs(req, from: attachments, args: getCreateArguments(req))
            }
    }
    
    public func updateAttachment(_ req: Request, updateAttachmentRequest: AttachmentDTO) -> Future<HTTPStatus> {
        let attachment = AttachmentModel(from: updateAttachmentRequest)
        return req.attachments
            .set(attachment)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }

    public func deleteAttachment(_ req: Request, deleteAttachmentRequest: UUIDRequest) -> Future<HTTPStatus> {
        return req.attachments
            .delete(id: deleteAttachmentRequest.id)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }
}
