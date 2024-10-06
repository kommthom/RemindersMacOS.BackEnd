//
//  RuleUseCase.swift
//  
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Vapor
import Fluent
import Resources
import DTO

public struct RuleUseCase: RuleUseCaseProtocol {
    public init() {
    }
    
    private func getAuthenticatedUser(_ req: Request) throws -> AuthenticatedUser? {
        if let authenticatedUser = req.auth.get(AuthenticatedUser.self) {
            return authenticatedUser
        } else {
            throw AuthenticationError.userNotFound
        }
    }
    
    private func translateRule(localization: LocalizationProtocol, language: LanguageIdentifier, rule: RuleModel) -> RuleModel {
        let description = localization.localize(rule.description, locale: language.code, interpolations: nil)
        if !description.isEmpty {
            let newRule = rule
            newRule.description = description
            return newRule
        } else {
            return rule
        }
    }
    
    public func createRule(_ req: Request, createRuleRequest: RuleDTO, taskId: UUID? = nil) -> Future<HTTPStatus> {
        do {
            return req.rules
                .createIfNotExists(
                    description: createRuleRequest.description,
                    ruleType: createRuleRequest.ruleType,
                    actionType: createRuleRequest.actionType,
                    args: createRuleRequest.args,
                    for: (try getAuthenticatedUser(req)?.id)!,
                    taskId: taskId)
                .transform(to: .created)
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }

    public func getSingleDTO(from model: RuleModel) -> RuleDTO {
        return RuleDTO(model: model)
    }
    
    public func getManyDTOs(from models: [RuleModel]) -> RulesDTO {
        return RulesDTO(many: models)
    }
    
    public func getRule(_ req: Request, getRuleRequest: UUIDRequest) -> Future<RuleDTO> {
        do {
            let localization = req.userLocalization
            let authenticatedUser = try getAuthenticatedUser(req)
            return req.rules
                .find(id: getRuleRequest.id)
                .unwrap(or: RuleControllerError.missingRule)
                .map { rule in
                    return getSingleDTO(from: translateRule(localization: localization, language: authenticatedUser!.locale.language, rule: rule))
                }
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func getRules(_ req: Request) -> Future<RulesDTO> {
        do {
            let localization = req.userLocalization
            let authenticatedUser = try getAuthenticatedUser(req)
            return req.rules
                .all(userId: (try getAuthenticatedUser(req)?.id)!)
                .flatMapEachThrowing { rule in
                    translateRule(localization: localization, language: authenticatedUser!.locale.language, rule: rule)
                }
                .map { rules in
                    return getManyDTOs(from: rules)
                }
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func updateRule(_ req: Request, updateRuleRequest: RuleDTO) -> Future<HTTPStatus> {
        do {
            let rule = RuleModel(from: updateRuleRequest, for: (try getAuthenticatedUser(req)?.id)!)
            return req.rules
                .set(rule)
                .flatMapErrorThrowing {
                    throw $0
                }
                .transform(to: .noContent)
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }

    public func deleteRule(_ req: Request, deleteRuleRequest: UUIDRequest) -> Future<HTTPStatus> {
        return req.rules
            .delete(id: deleteRuleRequest.id, force: false)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }
    
    public func getRulesWithSelection(_ req: Request, allWithSelectionRequest: UUIDRequest) -> Future<RuleSelectionsDTO> {
        do {
            return req.rules
                .allWithSelection(userId: (try getAuthenticatedUser(req)?.id)!, taskId: allWithSelectionRequest.id)
                .map { rules in
                    return RuleSelectionsDTO(for: allWithSelectionRequest.id, many: rules)
                }
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func updateSelection(_ req: Request, setSelectionRequest: RuleSelectionsDTO) -> Future<HTTPStatus> {
        do {
            let taskId: UUID? = setSelectionRequest.taskId
            let ruleIds: [UUID] = setSelectionRequest
                .ruleSelections
                .compactMap { ruleSelection in
                    if ruleSelection.isSelected {
                        return ruleSelection.rule.id
                    }
                    return nil
                }
            return req.rules
                .setSelection(userId: (try getAuthenticatedUser(req)?.id)!, taskId: taskId, ruleIds: ruleIds)
                .flatMapErrorThrowing {
                    throw $0
                }
                .transform(to: .noContent)
        } catch let error {
            return req.eventLoop.makeFailedFuture(error)
        }
    }
}
