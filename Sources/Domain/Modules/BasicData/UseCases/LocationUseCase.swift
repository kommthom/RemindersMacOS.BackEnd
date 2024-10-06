//
//  LocationUseCase.swift
//  
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import Fluent
import DTO

public struct LocationUseCase: LocationUseCaseProtocol {
    public init() {
    }

    public func createLocation(_ req: Request, createLocationRequest: LocationDTO) -> Future<HTTPStatus> {
        return req.locations
            .create(LocationModel(from: createLocationRequest))
            .flatMap {
                req.userLocalization.appendNew(createLocationRequest.description, value: .universal(value: createLocationRequest.localizedDescription), req: req)
            }
            .transform(to: .created)
    }

    public func getSingleDTO(from model: LocationModel, localization: @escaping (String) -> String) -> LocationDTO {
        return LocationDTO(model: model, localization: localization)
    }
    
    public func getManyDTOs(from models: [LocationModel], localization: @escaping (String) -> String) -> LocationsDTO {
        return LocationsDTO(many: models, localization: localization)
    }
    
    public func getLocation(_ req: Request, getLocationRequest: UUIDRequest) -> Future<LocationDTO> {
        return req.locations
            .find(id: getLocationRequest.id)
            .unwrap(or: LocationControllerError.missingLocation)
            .map { location in
                return getSingleDTO(from: location, localization: {
                    req.userLocalization.localize($0, interpolations: nil, req: req)
                })
            }
    }
    
    public func getLocations(_ req: Request) -> Future<LocationsDTO> {
        return req.locations
            .all()
            .flatMapErrorThrowing {
                throw $0
            }
            .map { locations in
                return getManyDTOs(from: locations, localization: {
                    req.userLocalization.localize($0, interpolations: nil, req: req)
                })
            }
    }
    
    public func updateLocation(_ req: Request, updateLocationRequest: LocationDTO) -> Future<HTTPStatus> {
        return req.locations
            .set(LocationModel(from: updateLocationRequest))
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }

    public func deleteLocation(_ req: Request, deleteLocationRequest: UUIDRequest) -> Future<HTTPStatus> {
        return req.locations
            .delete(id: deleteLocationRequest.id, force: true)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }
}

