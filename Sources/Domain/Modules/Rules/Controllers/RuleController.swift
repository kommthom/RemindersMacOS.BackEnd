//
//  RuleController.swift
//
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Vapor
import Fluent
import DTO

public struct RuleController: RouteCollection {
    private let useCase = RuleUseCase()
    private let logger = Logger(label: "reminders.backend.rules")
    
    public func boot(routes: RoutesBuilder) throws {
        routes.grouped("api", "rules").group(Payload.guardMiddleware()) { rule in
            rule.post("create", use: createRule)
            rule.post("get", use: getRule)
            rule.post("getall", use: getRules)
            rule.post("update", use: updateRule)
            rule.post("delete", use: deleteRule)
            rule.post("getforselection", use: getRulesWithSelection)
            rule.post("updateselection", use: updateRuleSelection)
        }
        routes.grouped("rules").grouped(UserSessionAuthenticator()).group(AuthenticatedUser.guardMiddleware()) { rule in
            //show Html
            rule.get("index", use: index)
            rule.get("add", use: add)
            rule.post("save", use: save)
            rule.get("show", use: show)
            rule.post("update", use: update)
            rule.post("delete", use: delete)
        }
    }

    public func createRule(_ req: Request) -> Future<HTTPStatus> {
        do {
            try RuleDTO.validate(content: req)
            let createRuleRequest = try req.content.decode(RuleDTO.self)
            return useCase.createRule(req, createRuleRequest: createRuleRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(RuleControllerError.unableToCreateNewRecord)
        }
    }

    public func getRule(_ req: Request) -> Future<RuleDTO> {
        do {
            let getRuleRequest = try req.content.decode(UUIDRequest.self)
            return useCase.getRule(req, getRuleRequest: getRuleRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(RuleControllerError.idParameterInvalid)
        }
    }

    public func getRules(_ req: Request) -> Future<RulesDTO> {
        return useCase.getRules(req)
    }

    public func updateRule(_ req: Request) -> Future<HTTPStatus> {
        do {
            try RuleDTO.validate(content: req)
            let rule = try req.content.decode(RuleDTO.self)
            return useCase.updateRule(req, updateRuleRequest: rule)
        } catch {
            return req.eventLoop.makeFailedFuture(RuleControllerError.unableToUpdateRecord)
        }
    }
    
    public func deleteRule(_ req: Request) -> Future<HTTPStatus> {
        do {
            let deleteRuleRequest = try req.content.decode(UUIDRequest.self)
            return useCase.deleteRule(req, deleteRuleRequest: deleteRuleRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(RuleControllerError.unableToDeleteRecord)
        }
    }
    
    public func getRulesWithSelection(_ req: Request) -> Future<RuleSelectionsDTO> {
        do {
            let allWithSelectionRequest = try req.content.decode(UUIDRequest.self)
            return useCase.getRulesWithSelection(req, allWithSelectionRequest: allWithSelectionRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(RuleControllerError.idParameterInvalid)
        }
    }
    
    public func updateRuleSelection(_ req: Request) -> Future<HTTPStatus> {
        do {
            try RuleSelectionsDTO.validate(content: req)
            let ruleSelectionsRequest = try req.content.decode(RuleSelectionsDTO.self)
            return useCase.updateSelection(req, setSelectionRequest: ruleSelectionsRequest)
        } catch {
            return req.eventLoop.makeFailedFuture(RuleControllerError.invalidForm)
        }
    }
    
    public func index(req: Request) -> Future<Response> {
        return useCase.getRules(req)
            .map() { rules in
                req.templates.renderHtml(RuleIndexTemplate(rules))
            }
    }

    public func show(req: Request) -> Future<Response> {
        do {
            let getRuleRequest = try req.content.decode(UUIDRequest.self)
            return showRule(req, getRuleRequest.id)
        } catch {
            return req.eventLoop.makeFailedFuture(RuleControllerError.idParameterMissing)
        }
    }

    private func showRule(_ req: Request, _ ruleId: UUID) -> Future<Response> {
        return getRule(req)
            .map() { rule in
                req.templates.renderHtml(RuleShowTemplate(rule))
            }
    }
    
    public func add(req: Request) -> Response {
        return req.templates.renderHtml(RuleAddTemplate())
    }

    public func save(req: Request)  -> Future<Response> {
        return createRule(req)
            .map { status in
                return req.redirect(to: "/rules/index")
            }
    }

    public func update(req: Request) -> Future<Response> {
        return updateRule(req)
            .map { status in
                return req.redirect(to: "/rules/index")
            }
    }

    public func delete(req: Request) -> Future<Response> {
        return deleteRule(req)
            .map { status in
                return req.redirect(to: "/rules/index")
            }
    }
}

