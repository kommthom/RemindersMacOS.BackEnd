//
//  RuleUseCaseProtocol.swift
//
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Vapor
import DTO

public protocol RuleUseCaseProtocol: UseCaseProtocol {
    func createRule(_ req: Request, createRuleRequest: RuleDTO, taskId: UUID?) -> Future<HTTPStatus>
    func getSingleDTO(from model: RuleModel) -> RuleDTO
    func getManyDTOs(from models: [RuleModel]) -> RulesDTO
    func getRule(_ req: Request, getRuleRequest: UUIDRequest) -> Future<RuleDTO>
    func getRules(_ req: Request) -> Future<RulesDTO>
    func updateRule(_ req: Request, updateRuleRequest: RuleDTO) -> Future<HTTPStatus>
    func deleteRule(_ req: Request, deleteRuleRequest: UUIDRequest) -> Future<HTTPStatus>
    func getRulesWithSelection(_ req: Request, allWithSelectionRequest: UUIDRequest) -> Future<RuleSelectionsDTO>
    func updateSelection(_ req: Request, setSelectionRequest: RuleSelectionsDTO) -> Future<HTTPStatus>
}
