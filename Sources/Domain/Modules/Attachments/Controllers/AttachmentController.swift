//
//  AttachmentController.swift
//  
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Vapor
import Fluent
import DTO

public struct AttachmentController: RouteCollection {
    private let useCase = AttachmentUseCase()
    private let logger = Logger(label: "reminders.backend.attachments")
    
    public func boot(routes: RoutesBuilder) throws {
        routes.grouped("api", "attachments").group(Payload.guardMiddleware()) { attachment in
            attachment.post("create", use: createAttachment)
            attachment.post("get", use: getAttachment)
            attachment.post("getall", use: getAttachments)
            attachment.post("update", use: updateAttachment)
            attachment.post("delete", use: deleteAttachment)
        }
        routes.grouped("attachments").grouped(UserSessionAuthenticator()).group(AuthenticatedUser.guardMiddleware()) { attachment in
            //show Html
            attachment.get("index", use: index)
            attachment.get("add", use: add)
            attachment.post("save", use: save)
            attachment.get("show", use: show)
            attachment.post("update", use: update)
            attachment.post("delete", use: delete)
        }
    }

    public func createAttachment(_ req: Request) -> Future<HTTPStatus> {
        do {
            try AttachmentDTO.validate(content: req)
            let attachmentRequest = try req.content.decode(AttachmentDTO.self)
            return useCase.createAttachment(req, createAttachmentRequest: attachmentRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(AttachmentControllerError.unableToCreateNewRecord)
        }
    }

    public func getAttachment(_ req: Request) -> Future<AttachmentDTO> {
        do {
            let getAttachmentRequest = try req.content.decode(UUIDRequest.self)
            return useCase.getAttachment(req, getAttachmentRequest: getAttachmentRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(AttachmentControllerError.idParameterInvalid)
        }
    }

    public func getAttachments(_ req: Request) -> Future<AttachmentsDTO> {
        do {
            let getAttachmentsRequest = try req.content.decode(UUIDRequest.self)
            return useCase.getAttachments(req, getAttachmentsRequest: getAttachmentsRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(AttachmentControllerError.idParameterInvalid)
        }
    }
    
    public func updateAttachment(_ req: Request) -> Future<HTTPStatus> {
        do {
            try AttachmentDTO.validate(content: req)
            let attachment = try req.content.decode(AttachmentDTO.self)
            return useCase.updateAttachment(req, updateAttachmentRequest: attachment)
        } catch {
            return req.eventLoop.makeFailedFuture(AttachmentControllerError.unableToUpdateRecord)
        }
    }
    
    public func deleteAttachment(_ req: Request) -> Future<HTTPStatus> {
        do {
            let deleteAttachmentRequest = try req.content.decode(UUIDRequest.self)
            return useCase.deleteAttachment(req, deleteAttachmentRequest: deleteAttachmentRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(AttachmentControllerError.unableToDeleteRecord)
        }
    }
    
    public func index(req: Request) -> Future<Response> {
        return getAttachments(req)
            .map() { attachments in
                req.templates.renderHtml(AttachmentIndexTemplate(attachments))
            }
    }

    public func show(req: Request) -> Future<Response> {
        do {
            let getAttachmentRequest = try req.content.decode(UUIDRequest.self)
            return showAttachment(req, getAttachmentRequest.id)
        } catch {
            return req.eventLoop.makeFailedFuture(AttachmentControllerError.idParameterMissing)
        }
    }

    private func showAttachment(_ req: Request, _ attachmentId: UUID) -> Future<Response> {
        return getAttachment(req)
            .map() { attachment in
                req.templates.renderHtml(AttachmentShowTemplate(attachment))
            }
    }
    
    public func add(req: Request) -> Response {
        return req.templates.renderHtml(AttachmentAddTemplate())
    }

    public func save(req: Request)  -> Future<Response> {
        return createAttachment(req)
            .map { status in
                return req.redirect(to: "/attachments/index")
            }
    }

    public func update(req: Request) -> Future<Response> {
        return updateAttachment(req)
            .map { status in
                return req.redirect(to: "/attachments/index")
            }
    }

    public func delete(req: Request) -> Future<Response> {
        return deleteAttachment(req)
            .map { status in
                return req.redirect(to: "/attachments/index")
            }
    }
}
