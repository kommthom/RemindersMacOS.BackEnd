//
//  TagUseCase.swift
//
//
//  Created by Thomas Benninghaus on 08.02.24.
//

import Vapor
import Fluent
import Resources
import DTO

public struct TagUseCase: TagUseCaseProtocol {
    public init() {
    }
    
    private func getAuthenticatedUser(_ req: Request) throws -> AuthenticatedUser? {
        if let authenticatedUser = req.auth.get(AuthenticatedUser.self) {
            return authenticatedUser
        } else {
            throw AuthenticationError.userNotFound
        }
    }
    
    private func translateTag(localization: LocalizationProtocol, language: LanguageIdentifier, tag: TagModel) -> TagModel {
        let description = localization.localize(tag.description, locale: language.code, interpolations: nil)
        if !description.isEmpty {
            let newTag = tag
            newTag.description = description
            return newTag
        } else {
            return tag
        }
    }
    
    public func createTag(_ req: Request, createTagRequest: TagDTO, taskId: UUID? = nil) -> Future<HTTPStatus> {
        do {
            return req.tags
                    .createIfNotExists(
                        description: createTagRequest.description,
                        color: createTagRequest.color,
                        for: (try getAuthenticatedUser(req)?.id)!,
                        taskId: taskId)
                    .transform(to: .created)
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }

    public func getSingleDTO(from model: TagModel) -> TagDTO {
        return TagDTO(model: model)
    }
    
    public func getManyDTOs(from models: [TagModel]) -> TagsDTO {
        return TagsDTO(many: models)
    }
    
    public func getTag(_ req: Request, getTagRequest: UUIDRequest) -> Future<TagDTO> {
        do {
            let localization = req.userLocalization
            let authenticatedUser = try getAuthenticatedUser(req)
            return req.tags
                .find(id: getTagRequest.id)
                .unwrap(or: TagControllerError.missingTag)
                .map { tag in
                    return getSingleDTO(from: translateTag(localization: localization, language: authenticatedUser!.locale.language, tag: tag))
                }
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func getTags(_ req: Request) -> Future<TagsDTO> {
        do {
            let localization = req.userLocalization
            let authenticatedUser = try getAuthenticatedUser(req)
            return req.tags
                .all(userId: (try getAuthenticatedUser(req)?.id)!)
                .flatMapEachThrowing { tag in
                    translateTag(localization: localization, language: authenticatedUser!.locale.language, tag: tag)
                }
                .map { tags in
                    return getManyDTOs(from: tags)
                }
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func updateTag(_ req: Request, updateTagRequest: TagDTO) -> Future<HTTPStatus> {
        do {
            let tag = TagModel(from: updateTagRequest, for: (try getAuthenticatedUser(req)?.id)!)
            return req.tags
                .set(tag)
                .flatMapErrorThrowing {
                    throw $0
                }
                .transform(to: .noContent)
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }

    public func deleteTag(_ req: Request, deleteTagRequest: UUIDRequest) -> Future<HTTPStatus> {
        return req.tags
            .delete(id: deleteTagRequest.id, force: false)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }
    
    public func getTagsWithSelection(_ req: Request, allWithSelectionRequest: UUIDRequest) -> Future<TagSelectionsDTO> {
        do {
            return req.tags
                .allWithSelection(userId: (try getAuthenticatedUser(req)?.id)!, taskId: allWithSelectionRequest.id)
                .map { tags in
                    return TagSelectionsDTO(for: allWithSelectionRequest.id, many: tags)
                }
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func updateSelection(_ req: Request, setSelectionRequest: TagSelectionsDTO) -> Future<HTTPStatus> {
        do {
            let taskId: UUID? = setSelectionRequest.taskId
            let tagIds: [UUID] = setSelectionRequest
                .tagSelections
                .compactMap { tagSelection in
                    if tagSelection.isSelected {
                        return tagSelection.tag.id
                    }
                    return nil
                }
            return req.tags
                .setSelection(userId: (try getAuthenticatedUser(req)?.id)!, taskId: taskId, tagIds: tagIds)
                .flatMapErrorThrowing {
                    throw $0
                }
                .transform(to: .noContent)
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
}
