//
//  DateComponentInterval.swift
//
//
//  Created by Thomas Benninghaus on 05.04.24.
//

import Foundation

public class DateComponentInterval: Codable, RawRepresentable {
    public var component: DateComponent?
    public var listType: DateComponentListType
    public var dateRelativeList: DateRelativeList?
    public var every: Int?
    public var child: DateComponentInterval?
    
    public init(component: DateComponent? = nil, listType: DateComponentListType, dateRelativeList: DateRelativeList? = nil, every: Int? = nil, child: DateComponentInterval? = nil) {
        self.component = component
        self.listType = listType
        self.dateRelativeList = dateRelativeList
        self.every = every
        self.child = child
    }
    
//extension DateComponentInterval: RawRepresentable {
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        String(data: try! JSONEncoder().encode(self), encoding: .utf8)!
    }
    
    public required convenience init?(rawValue: String) {
        let jsonData = rawValue.data(using: .utf8)!
        guard let dayInterval = try? JSONDecoder().decode(DateComponentInterval.self, from: jsonData) else { return nil }
        self.init(component: dayInterval.component, listType: dayInterval.listType, dateRelativeList: dayInterval.dateRelativeList, every: dayInterval.every, child: dayInterval.child)
    }
}

extension DateComponentInterval: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(component)
        hasher.combine(listType)
        hasher.combine(dateRelativeList)
        hasher.combine(every)
        hasher.combine(child)
    }
    
    public static func == (lhs: DateComponentInterval, rhs: DateComponentInterval) -> Bool {
        lhs.component == rhs.component && lhs.listType == rhs.listType && lhs.dateRelativeList == rhs.dateRelativeList && lhs.every == rhs.every && lhs.child == rhs.child
    }
}
