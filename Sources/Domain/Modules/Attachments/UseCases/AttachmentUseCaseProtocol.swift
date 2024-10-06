//
//  AttachmentUseCaseProtocol.swift
//
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Vapor
import DTO

public protocol AttachmentUseCaseProtocol: UseCaseProtocol {
    func createAttachment(_ req: Request, createAttachmentRequest: AttachmentDTO) -> Future<HTTPStatus>
    func getCreateArguments(_ req: Request) -> AttachmentDTO.CreateArguments
    func getSingleDTO(_ req: Request, from model: AttachmentModel, args: AttachmentDTO.CreateArguments) -> Future<AttachmentDTO?>
    func getManyDTOs(_ req: Request, from models: [AttachmentModel], args: AttachmentDTO.CreateArguments?) -> Future<AttachmentsDTO?>
    func getAttachment(_ req: Request, getAttachmentRequest: UUIDRequest) -> Future<AttachmentDTO?>
    func getAttachments(_ req: Request, getAttachmentsRequest: UUIDRequest) -> Future<AttachmentsDTO?>
    func updateAttachment(_ req: Request, updateAttachmentRequest: AttachmentDTO) -> Future<HTTPStatus>
    func deleteAttachment(_ req: Request, deleteAttachmentRequest: UUIDRequest) -> Future<HTTPStatus>
}
