//
//  RepetitionFromParse.swift
//  
//
//  Created by Thomas Benninghaus on 16.04.24.
//

import Foundation

public struct RepetitionFromParse: Codable {
    public var iteration: Int
    public var fromDone: Bool
    public var repetitionNumber: Int
    public var repetitionJSON: String
    public var repetitionBegin: Date?
    public var repetitionEnd: Date?
    public var maxIterations: Int?
    
    public enum CodingKeys: String, CodingKey {
        case iteration, fromDone, repetitionNumber, repetitionJSON, repetitionBegin, repetitionEnd, maxIterations
    }
    
    public init(iteration: Int, fromDone: Bool, repetitionNumber: Int, repetitionJSON: String, repetitionBegin: Date? = nil, repetitionEnd: Date? = nil, maxIterations: Int? = nil) {
        self.iteration = iteration
        self.fromDone = fromDone
        self.repetitionNumber = repetitionNumber
        self.repetitionJSON = repetitionJSON
        self.repetitionBegin = repetitionBegin
        self.repetitionEnd = repetitionEnd
        self.maxIterations = maxIterations
    }
}
