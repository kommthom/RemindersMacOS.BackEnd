//
//  TagUseCaseProtocol.swift
//
//
//  Created by Thomas Benninghaus on 08.02.24.
//

import Vapor
import DTO

public protocol TagUseCaseProtocol: UseCaseProtocol {
    func createTag(_ req: Request, createTagRequest: TagDTO, taskId: UUID?) -> Future<HTTPStatus>
    func getSingleDTO(from model: TagModel) -> TagDTO
    func getManyDTOs(from models: [TagModel]) -> TagsDTO
    func getTag(_ req: Request, getTagRequest: UUIDRequest) -> Future<TagDTO>
    func getTags(_ req: Request) -> Future<TagsDTO>
    func updateTag(_ req: Request, updateTagRequest: TagDTO) -> Future<HTTPStatus>
    func deleteTag(_ req: Request, deleteTagRequest: UUIDRequest) -> Future<HTTPStatus>
    func getTagsWithSelection(_ req: Request, allWithSelectionRequest: UUIDRequest) -> Future<TagSelectionsDTO>
    func updateSelection(_ req: Request, setSelectionRequest: TagSelectionsDTO) -> Future<HTTPStatus>
}
