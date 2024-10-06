//
//  CountryUseCaseProtocol.swift
//
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import DTO

public protocol CountryUseCaseProtocol: UseCaseProtocol {
    func createCountry(_ req: Request, createCountryRequest: CountryDTO) -> Future<HTTPStatus>
    func getSingleDTO(from model: CountryModel, localization: @escaping (String) -> String) -> CountryDTO
    func getManyDTOs(from models: [CountryModel], localization: @escaping (String) -> String) -> CountriesDTO
    func getCountry(_ req: Request, getCountryRequest: UUIDRequest) -> Future<CountryDTO>
    func getCountries(_ req: Request) -> Future<CountriesDTO>
    func updateCountry(_ req: Request, updateCountryRequest: CountryDTO) -> Future<HTTPStatus>
    func deleteCountry(_ req: Request, deleteCountryRequest: UUIDRequest) -> Future<HTTPStatus>
}
