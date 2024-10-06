//
//  TransformedComponent.swift
//  
//
//  Created by Thomas Benninghaus on 16.04.24.
//

import Foundation

public class TransformedComponent {
    public var transformedComponentType: RepetitionFromParse.CodingKeys?
    public var fromDone: Bool?
    public var parsedComponentsIndices: [Int]
    public var child: DateComponentInterval?
    public var state: AnalyzeStep?
    
    public var releasable: Bool {
        if let _ = transformedComponentType, parsedComponentsIndices.count > 0 {
            if let _ = fromDone { return true }
            else if let _ = child?.component {
                if let _ = child?.every { return true }
                else if let _ = child?.dateRelativeList  { return true }
            }
        }
        return false
    }
    
    public init(transformedComponentType: RepetitionFromParse.CodingKeys? = nil, fromDone: Bool? = nil, intValue: Int? = nil, parsedComponentsIndices: [Int] = .init(), child: DateComponentInterval? = nil, successState: AnalyzeStep = .transformedComponentInitialzedUniveral) {
        self.parsedComponentsIndices = parsedComponentsIndices
        self.child = child
        self.transformedComponentType = transformedComponentType
        self.fromDone = fromDone
        self.state = successState
    }
    
    public convenience init(transformedComponentType: RepetitionFromParse.CodingKeys? = .repetitionJSON, index: Int, fixedDate: Date?, formatType: CustomDateFormatType = .hhmm, successState: AnalyzeStep = .createNewDateComponent) {
        self.init(transformedComponentType: transformedComponentType, parsedComponentsIndices: [index], child: DateComponentInterval(component: formatType.calculatorType, listType: .fixed, dateRelativeList: DateRelativeList(items: fixedDate == nil ? [] : [DateRelative(fixedDate!, formatType: formatType)!]), every: 1), successState: successState)
    }
    
    public convenience init(transformedComponentType: RepetitionFromParse.CodingKeys? = .repetitionJSON, index: Int, fixedDate: DateRelative?, successState: AnalyzeStep = .createNewDateComponent) {
        self.init(transformedComponentType: transformedComponentType, parsedComponentsIndices: [index], child: DateComponentInterval(component: fixedDate!.formatType.calculatorType, listType: .fixed, dateRelativeList: DateRelativeList(items: fixedDate == nil ? [] : [fixedDate!]), every: 1), successState: successState)
    }
    
    public convenience init(transformedComponentType: RepetitionFromParse.CodingKeys? = .repetitionJSON, index: Int, every: Int? = nil, component: DateComponent? = nil, successState: AnalyzeStep = .createNewRepeatingComponent) {
        self.init(transformedComponentType: transformedComponentType, parsedComponentsIndices: [index], child: DateComponentInterval(component: component, listType: .every, every: every), successState: successState)
        state = successState
    }
    
    public convenience init(transformedComponentType: RepetitionFromParse.CodingKeys? = .repetitionJSON, index: Int, every: Int? = nil, typeOfDay: TypeOfDay, successState: AnalyzeStep = .createNewTypedDayComponent) {
        self.init(transformedComponentType: transformedComponentType, parsedComponentsIndices: [index], child: DateComponentInterval(component: .day, listType: .every, dateRelativeList: DateRelativeList(items: [DateRelative(day: -1, dayType: typeOfDay.typeOfDayNo, dayFilter: typeOfDay)]), every: every), successState: successState)
        state = successState
    }
    
    public func appendIndex(index: Int, successState: AnalyzeStep = .indexAdded) -> TransformedComponent {
        self.parsedComponentsIndices.append(index)
        self.state = successState
        return self
    }
    
    public func appendDate(index: Int, fixedDate: Date, formatType: CustomDateFormatType = .hhmm, successState: AnalyzeStep = .repetitionDateAdded) -> TransformedComponent {
        self.child!.dateRelativeList!.items.append(DateRelative(fixedDate, formatType: formatType)!)
        self.parsedComponentsIndices.append(index)
        self.state = successState
        return self
    }
    
    public func appendDayMonthYear(index: Int, fixedDate: DateRelative, successState: AnalyzeStep = .repetitionDayMonthYearAdded) -> TransformedComponent {
        self.child!.dateRelativeList!.items.append(fixedDate)
        self.parsedComponentsIndices.append(index)
        self.state = successState
        return self
    }
    
    public func setRepetitionNo(index: Int, every: Int, successState: AnalyzeStep = .repetitionEverySet) -> TransformedComponent {
        self.child!.every = every
        self.parsedComponentsIndices.append(index)
        self.state = successState
        return self
    }
    
    public func setComponentType(index: Int, component: DateComponent, successState: AnalyzeStep = .repetitionComponentTypeSet) -> TransformedComponent {
        if component == .quarter {
            self.child!.component = .month
            self.child!.every = (self.child?.every ?? 1) * 3
        } else {
            self.child!.component = component
        }
        self.parsedComponentsIndices.append(index)
        self.state = successState
        return self
    }
    
    public func appendTypedDay(index: Int, every: Int? = nil, typeOfDay: TypeOfDay, successState: AnalyzeStep = .repetitionTypedDayAdded) -> TransformedComponent {
        self.child!.every = every
        self.child!.dateRelativeList!.items.append(DateRelative(day: -1, dayType: typeOfDay.typeOfDayNo, dayFilter: typeOfDay))
        self.parsedComponentsIndices.append(index)
        self.state = successState
        return self
    }
}

extension TransformedComponent: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(parsedComponentsIndices)
        hasher.combine(child)
        hasher.combine(transformedComponentType)
        hasher.combine(fromDone)
    }

    public static func == (lhs: TransformedComponent, rhs: TransformedComponent) -> Bool {
        lhs.parsedComponentsIndices == rhs.parsedComponentsIndices && lhs.child == rhs.child && lhs.transformedComponentType == rhs.transformedComponentType && lhs.fromDone == rhs.fromDone
    }
}

extension TransformedComponent: Comparable {
    public static func < (lhs: TransformedComponent, rhs: TransformedComponent) -> Bool {
        lhs.child?.component?.rawValue ?? 0 < rhs.child?.component?.rawValue ?? 0
    }
}
    
extension Predicate where Target == TransformedComponent {
    public static func isOfType(transformedComponentType: RepetitionFromParse.CodingKeys) -> Self {
        Predicate { return $0.transformedComponentType == transformedComponentType }
    }
}
