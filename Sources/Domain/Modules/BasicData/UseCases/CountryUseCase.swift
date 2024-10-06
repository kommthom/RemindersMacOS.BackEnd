//
//  CountryUseCase.swift
//  
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import Fluent
import DTO

public struct CountryUseCase: CountryUseCaseProtocol {
    public init() {
    }

    public func createCountry(_ req: Request, createCountryRequest: CountryDTO) -> Future<HTTPStatus> {
        return req.countries
            .create(CountryModel(from: createCountryRequest))
            .flatMap {
                req.userLocalization.appendNew(createCountryRequest.description, value: .universal(value: createCountryRequest.localizedDescription), req: req)
            }
            .transform(to: .created)
    }

    public func getSingleDTO(from model: CountryModel, localization: @escaping (String) -> String) -> CountryDTO {
        return CountryDTO(model: model, localization: localization)
    }
    
    public func getManyDTOs(from models: [CountryModel], localization: @escaping (String) -> String) -> CountriesDTO {
        return CountriesDTO(many: models, localization: localization)
    }
    
    public func getCountry(_ req: Request, getCountryRequest: UUIDRequest) -> Future<CountryDTO> {
        return req.countries
            .find(id: getCountryRequest.id)
            .unwrap(or: CountryControllerError.missingCountry)
            .map { country in
                return getSingleDTO(from: country, localization: {
                    req.userLocalization.localize($0, interpolations: nil, req: req)
                })
            }
    }
    
    public func getCountries(_ req: Request) -> Future<CountriesDTO> {
        return req.countries
            .all()
            .flatMapErrorThrowing {
                throw $0
            }
            .map { countries in
                return getManyDTOs(from: countries, localization: {
                    req.userLocalization.localize($0, interpolations: nil, req: req)
                })
            }
    }
    
    public func updateCountry(_ req: Request, updateCountryRequest: CountryDTO) -> Future<HTTPStatus> {
        return req.countries
            .set(CountryModel(from: updateCountryRequest))
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }

    public func deleteCountry(_ req: Request, deleteCountryRequest: UUIDRequest) -> Future<HTTPStatus> {
        return req.countries
            .delete(id: deleteCountryRequest.id)
            .flatMapErrorThrowing {
                throw $0
            }
            .transform(to: .noContent)
    }
}
