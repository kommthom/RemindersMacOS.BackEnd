//
//  TagController.swift
//
//
//  Created by Thomas Benninghaus on 08.02.24.
//

import Vapor
import Fluent
import DTO

public struct TagController: RouteCollection {
    private let useCase = TagUseCase()
    private let logger = Logger(label: "reminders.backend.tags")
    
    public func boot(routes: RoutesBuilder) throws {
        routes.grouped("api", "tags").group(Payload.guardMiddleware()) { tag in
            tag.post("create", use: createTag)
            tag.post("get", use: getTag)
            tag.post("getall", use: getTags)
            tag.post("update", use: updateTag)
            tag.post("delete", use: deleteTag)
            tag.post("getforselection", use: getTagsWithSelection)
            tag.post("updateselection", use: updateTagSelection)
        }
        routes.grouped("tags").grouped(UserSessionAuthenticator()).group(AuthenticatedUser.guardMiddleware()) { tag in
            //show Html
            tag.get("index", use: index)
            tag.get("add", use: add)
            tag.post("save", use: save)
            tag.get("show", use: show)
            tag.post("update", use: update)
            tag.post("delete", use: delete)
        }
    }

    public func createTag(_ req: Request) -> Future<HTTPStatus> {
        do {
            try TagDTO.validate(content: req)
            let createTagRequest = try req.content.decode(TagDTO.self)
            return useCase.createTag(req, createTagRequest: createTagRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(TagControllerError.unableToCreateNewRecord)
        }
    }

    public func getTag(_ req: Request) -> Future<TagDTO> {
        do {
            let getTagRequest = try req.content.decode(UUIDRequest.self)
            return useCase.getTag(req, getTagRequest: getTagRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(TagControllerError.idParameterInvalid)
        }
    }

    public func getTags(_ req: Request) -> Future<TagsDTO> {
        return useCase.getTags(req)
    }

    public func updateTag(_ req: Request) -> Future<HTTPStatus> {
        do {
            try TagDTO.validate(content: req)
            let tag = try req.content.decode(TagDTO.self)
            return useCase.updateTag(req, updateTagRequest: tag)
        } catch {
            return req.eventLoop.makeFailedFuture(TagControllerError.unableToUpdateRecord)
        }
    }
    
    public func deleteTag(_ req: Request) -> Future<HTTPStatus> {
        do {
            let deleteTagRequest = try req.content.decode(UUIDRequest.self)
            return useCase.deleteTag(req, deleteTagRequest: deleteTagRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(TagControllerError.unableToDeleteRecord)
        }
    }
    
    public func getTagsWithSelection(_ req: Request) -> Future<TagSelectionsDTO> {
        do {
            let allWithSelectionRequest = try req.content.decode(UUIDRequest.self)
            return useCase.getTagsWithSelection(req, allWithSelectionRequest: allWithSelectionRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(TagControllerError.idParameterInvalid)
        }
    }
    
    public func updateTagSelection(_ req: Request) -> Future<HTTPStatus> {
        do {
            try TagSelectionsDTO.validate(content: req)
            let tagSelectionsRequest = try req.content.decode(TagSelectionsDTO.self)
            return useCase.updateSelection(req, setSelectionRequest: tagSelectionsRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(TagControllerError.invalidForm)
        }
    }
    
    public func index(req: Request) -> Future<Response> {
        return useCase.getTags(req)
            .map() { tags in
                req.templates.renderHtml(TagIndexTemplate(tags))
            }
    }

    public func show(req: Request) -> Future<Response> {
        do {
            let getTagRequest = try req.content.decode(UUIDRequest.self)
            return showTag(req, getTagRequest.id)
        } catch {
            return req.eventLoop.makeFailedFuture(TagControllerError.idParameterMissing)
        }
    }

    private func showTag(_ req: Request, _ tagId: UUID) -> Future<Response> {
        return getTag(req)
            .map() { tag in
                req.templates.renderHtml(TagShowTemplate(tag))
            }
    }
    
    public func add(req: Request) -> Response {
        return req.templates.renderHtml(TagAddTemplate())
    }

    public func save(req: Request)  -> Future<Response> {
        return createTag(req)
            .map { status in
                return req.redirect(to: "/tags/index")
            }
    }

    public func update(req: Request) -> Future<Response> {
        return updateTag(req)
            .map { status in
                return req.redirect(to: "/tags/index")
            }
    }

    public func delete(req: Request) -> Future<Response> {
        return deleteTag(req)
            .map { status in
                return req.redirect(to: "/tags/index")
            }
    }
}
