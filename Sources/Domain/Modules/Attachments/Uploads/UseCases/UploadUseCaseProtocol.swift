//
//  UploadUseCaseProtocol.swift
//  
//
//  Created by Thomas Benninghaus on 01.05.24.
//

import Vapor
import DTO

public protocol UploadUseCaseProtocol: UseCaseProtocol {
    func createUpload(_ req: Request, createUploadRequest: UploadDTO) -> Future<HTTPStatus>
    func createUploads(_ req: Request, createUploadsRequest: UploadsDTO) -> Future<HTTPStatus>
    func getManyDTOs(_ req: Request, from models: [UploadModel]) -> Future<UploadsDTO?>
    func getSingleDTO(_ req: Request, from model: UploadModel) -> Future<UploadDTO?>
    func getUpload(_ req: Request, getUploadRequest: UUIDRequest) -> Future<UploadDTO?>
    func getUploads(_ req: Request, getUploadsRequest: UUIDRequest) -> Future<UploadsDTO?>
    func deleteUpload(_ req: Request, deleteUploadRequest: UUIDRequest) -> Future<HTTPStatus>
}
