//
//  LocationUseCaseProtocol.swift
//  
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import DTO

public protocol LocationUseCaseProtocol: UseCaseProtocol {
    func createLocation(_ req: Request, createLocationRequest: LocationDTO) -> Future<HTTPStatus>
    func getSingleDTO(from model: LocationModel, localization: @escaping (String) -> String) -> LocationDTO
    func getManyDTOs(from models: [LocationModel], localization: @escaping (String) -> String) -> LocationsDTO
    func getLocation(_ req: Request, getLocationRequest: UUIDRequest) -> Future<LocationDTO>
    func getLocations(_ req: Request) -> Future<LocationsDTO>
    func updateLocation(_ req: Request, updateLocationRequest: LocationDTO) -> Future<HTTPStatus>
    func deleteLocation(_ req: Request, deleteLocationRequest: UUIDRequest) -> Future<HTTPStatus>
}
