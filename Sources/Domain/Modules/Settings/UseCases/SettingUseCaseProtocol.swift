//
//  SettingUseCaseProtocol.swift
//  
//
//  Created by Thomas Benninghaus on 31.01.24.
//

import Vapor
import DTO

public protocol SettingUseCaseProtocol: UseCaseProtocol {
    func createSetting(_ req: Request, createSettingRequest: SettingDTO) -> Future<HTTPStatus>
    func getSetting(_ req: Request, getSettingRequest: UUIDRequest) -> Future<SettingDTO>
    func getSettings(_ req: Request) -> Future<SettingsDTO>
    func getSettingsByScope(_ req: Request, getSettingsRequest: GetSettingsRequest) -> Future<SettingsDTO>
    func getSidebar(_ req: Request) -> Future<SettingsDTO>
    func updateSetting(_ req: Request, updateSettingRequest: SettingDTO) -> Future<HTTPStatus>
    func deleteSetting(_ req: Request, deleteSettingRequest: UUIDRequest) -> Future<HTTPStatus>
}
