//
//  UploadRepositoryProtocol.swift
//
//
//  Created by Thomas Benninghaus on 01.05.24.
//

import Vapor
import Fluent

public protocol UploadRepositoryProtocol: DBRepositoryProtocol, UploadRepositoryMockProtocol {
    func create(_ upload: UploadModel) -> Future<Void>
    func delete(id: UUID) -> Future<Void>
    func all(for attachmentId: UUID) -> Future<[UploadModel]>
    func find(id: UUID?) -> Future<UploadModel?>
    func count(for attachmentId: UUID) -> Future<Int>
}

public protocol UploadRepositoryMockProtocol {
    func getDemo(_ exampleNo: Int, attachmentId: UUID) -> [UploadModel]
    func createDemo(_ exampleNo: Int, attachmentId: UUID) -> Future<[UploadModel]>
}
