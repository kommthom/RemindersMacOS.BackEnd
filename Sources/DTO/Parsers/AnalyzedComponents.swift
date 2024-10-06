//
//  AnalyzedComponents.swift
//
//
//  Created by Thomas Benninghaus on 20.04.24.
//

import Foundation

public class AnalyzedComponents {
    public enum TypeOfComponent: CaseIterable {
        case repetitionNumber, fromDone, repetition, repetitionBegin, repetitionEnd, maxIterations
    }
    
    public var repetitionNumber: TransformedComponent?
    public var fromDone: TransformedComponent?
    public var repetition: TransformedComponent?
    public var repetitionBegin: TransformedComponent?
    public var repetitionEnd: TransformedComponent?
    public var maxIterations: TransformedComponent?
    public var release: TransformedComponent?
    public var steps: AnalyzeSteps = AnalyzeSteps(.initialized)
    public var currentType: TypeOfComponent?
    public var current: TransformedComponent? {
        get {
            guard let _ = currentType else { return nil }
            return getComponent(type: currentType!)
        }
        set {
            guard let _ = currentType else { return }
            setComponent(type: currentType!, newValue: newValue)
        }
    }
    
    public var currentState: AnalyzeStep? {
        steps.items.last
    }
    
    public func stepsAppend(_ step: AnalyzeStep) -> AnalyzedComponents {
        steps.append(step)
        return self
    }
    
    public func create(type: TypeOfComponent = .repetition, create: () -> TransformedComponent?) -> AnalyzedComponents {
        currentType = type
        switch type {
            case .repetitionNumber: self.repetitionNumber = create(); steps.append(repetitionNumber!.state!)
            case .fromDone: self.fromDone = create(); steps.append(fromDone!.state!)
            case .repetition: self.repetition = create(); steps.append(repetition!.state!)
            case .repetitionBegin: self.repetitionBegin = create(); steps.append(repetitionBegin!.state!)
            case .repetitionEnd: self.repetitionEnd = create(); steps.append(repetitionEnd!.state!)
            case .maxIterations: self.maxIterations = create(); steps.append(maxIterations!.state!)
        }
        return self
    }
    
    public func createOrUpdate(type: TypeOfComponent = .repetition, create: (() -> TransformedComponent)? = nil, update: ((_ component: TransformedComponent) -> TransformedComponent)? = nil, condition: ((_ component: TransformedComponent) -> Bool) = { component in true }, updateElse:  ((_ component: TransformedComponent) -> TransformedComponent)? = nil) -> AnalyzedComponents {
        var returnValue: AnalyzeStep
        currentType = type
        if let component = current {
            if condition(component) {
                if let _ = update {
                    current = update!(component)
                    returnValue = current?.state ?? .createOrUpdateFailed
                } else { returnValue = .createOrUpdateFailed }
            } else if let _ = updateElse {
                current = updateElse!(component)
                returnValue = current?.state ?? .createOrUpdateFailed
            } else { returnValue = .createOrUpdateFailed }
        } else if let _ = create {
            current = create!()
            returnValue = current?.state ?? .createOrUpdateFailed
        } else { returnValue = .createOrUpdateFailed }
        steps.append(returnValue)
        return self
    }
    
    public func getComponent(type: TypeOfComponent = .repetition) -> TransformedComponent? {
        currentType = type
        return switch type {
            case .repetitionNumber: repetitionNumber
            case .fromDone: fromDone
            case .repetition: repetition
            case .repetitionBegin: repetitionBegin
            case .repetitionEnd: repetitionEnd
            case .maxIterations: maxIterations
        }
    }
    
    public func setComponent(type: TypeOfComponent = .repetition, newValue: TransformedComponent?) {
        currentType = type
        switch type {
            case .repetitionNumber: repetitionNumber = newValue
            case .fromDone: fromDone = newValue
            case .repetition: repetition = newValue
            case .repetitionBegin: repetitionBegin = newValue
            case .repetitionEnd: repetitionEnd = newValue
            case .maxIterations: maxIterations = newValue
        }
    }
    
    public func releaseAndCreateOrUpdate(type: TypeOfComponent = .repetition, create: (() -> TransformedComponent)? = nil, condition: ((_ component: TransformedComponent) -> Bool) = { component in true }, update:  ((_ component: TransformedComponent) -> TransformedComponent)? = nil) -> AnalyzedComponents {
        var returnValue: AnalyzeStep = release(type: type).currentState!
        currentType = type
        if let component = current {
            if condition(component) {
                if let _ = create {
                    current = create!()
                    returnValue = current?.state ?? .createOrUpdateFailed
                } else { returnValue = .createOrUpdateFailed }
            } else if let _ = update {
                current = update!(component)
                returnValue = current!.state!
            } else { returnValue = .createOrUpdateFailed }
        } else if let _ = create {
            current = create!()
            returnValue = current?.state ?? .createOrUpdateFailed
        } else { returnValue = .createOrUpdateFailed }
        steps.append(returnValue)
        return self
    }
    
    public func release(type: TypeOfComponent? = nil) -> AnalyzedComponents {
        if let releaseType = type == nil ? currentType : type {
            if let _ = release, !current!.releasable { steps.append(.releaseFailure) } else {
                switch releaseType {
                    case .repetitionNumber: release = repetitionNumber; repetitionNumber = nil; steps.append(.releasedRepetitionNumber)
                    case .fromDone: release = fromDone; fromDone = nil; steps.append(.releasedFromDone)
                    case .repetition: release = repetition; repetition = nil; steps.append(.releasedRepetition)
                    case .repetitionBegin: release = repetitionBegin; repetitionBegin = nil; steps.append(.releasedRepetitionBegin)
                    case .repetitionEnd: release = repetitionEnd; repetitionEnd = nil; steps.append(.releasedRepetitionEnd)
                    case .maxIterations: release = maxIterations; maxIterations = nil; steps.append(.releasedMaxIterations)
                }
            }
        } else { steps.append(.releaseFailure) }
        currentType = nil
        return self
    }
    
    public func returnValue(type: TypeOfComponent? = nil) -> TransformedComponent? {
        if let _ = type {
            guard let tempComponent = getComponent(type: type!) else { return nil }
            setComponent(type: type!, newValue: nil)
            steps.append(.released)
            return tempComponent
        } else {
            guard let tempComponent = release else { return nil }
            release = nil
            steps.append(.released)
            return tempComponent
        }
    }
    
    public func getAllNotNil() -> [TransformedComponent] {
        TypeOfComponent.allCases.compactMap { returnValue(type: $0) }
    }
}
