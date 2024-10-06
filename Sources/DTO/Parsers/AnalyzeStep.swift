//
//  AnalyzeStep.swift
//
//
//  Created by Thomas Benninghaus on 20.04.24.
//

import Foundation

public enum AnalyzeStep: String, RawRepresentable {
    //// process information
    case initialized, createOrUpdateFailed, released, releasedFromDone, releasedRepetitionNumber, releasedRepetition, releasedRepetitionBegin, releasedRepetitionEnd, releasedMaxIterations, releaseFailure
    //// keywords
    case keywordRepeatingFound, keywordRepetitionNumberFound, keywordDateInitFound, keywordRepetitionStartingFound, keywordRepetitionEndingFound, keywordMaxIterationsFound, listSeparatorFound, keywordDateTimeSpanFound
    case keywordTypeOfDayFound, keywordTimeOfDayFound, keywordIntNameFound, intValueFound, dateValueFound, timeValueFound, dateRelativeFound, dateComponentValueFound, weekdayFound
    //// repeating component
    case createNewRepeatingComponent, createDefaultRepeatingComponent, createNewDateComponent, createNewTimeComponent, createNewTypedDayComponent, createNewWeekdayComponent
    case repetitionTypedDayAdded, repetitionDayMonthYearAdded, repetitionNumberAdded, repetitionDateAdded, repetitionEverySet, repetitionComponentTypeSet
    case repetitionListSeparatorAdded, createNewDateInitComponent
    //// from Done component
    case fromDoneCreated
    //// repetition number component
    case repetitionNumberInitialized, repetitionNumberCompleted
    //// repetition starting at component
    case repetitionStartingInitialized, repetitionStartingDateAdded
    /// repetition ending component
    case repetitionEndingInitialized, repetitionEndingDateAdded
    /// max iterations component
    case maxIterationsInitialized, maxIterationsNumberAdded
    /// universal
    case transformedComponentInitialzedUniveral, indexAdded
    
    public var isProcessInformationStep: Bool {
        switch self {
            case .initialized, .createOrUpdateFailed, .released, .releasedFromDone, .releasedRepetitionNumber, .releasedRepetition, .releasedRepetitionBegin, .releasedRepetitionEnd, .releasedMaxIterations, .releaseFailure: true
            default: false
        }
    }
    
    public var transformedComponentType: RepetitionFromParse.CodingKeys? {
        switch self {
        case .createNewRepeatingComponent, .createDefaultRepeatingComponent, .createNewDateComponent, .createNewTimeComponent, .createNewTypedDayComponent, .createNewWeekdayComponent: .repetitionJSON
            case .repetitionTypedDayAdded, .repetitionDayMonthYearAdded, .repetitionNumberAdded, .repetitionDateAdded, .repetitionEverySet, .repetitionComponentTypeSet: .repetitionJSON
            case .repetitionListSeparatorAdded, .createNewDateInitComponent: .repetitionJSON
            case .fromDoneCreated: .fromDone
            case .repetitionNumberInitialized, .repetitionNumberCompleted: .repetitionNumber
            case .repetitionStartingInitialized, .repetitionStartingDateAdded: .repetitionBegin
            case .repetitionEndingInitialized, .repetitionEndingDateAdded: .repetitionEnd
            case .maxIterationsInitialized, .maxIterationsNumberAdded: .maxIterations
            default: nil
        }
    }
}

public class AnalyzeSteps {
    var items: [AnalyzeStep]
    
    init(_ firstStep: AnalyzeStep = .initialized) {
        self.items = [firstStep]
    }
    
    func append(_ step: AnalyzeStep) {
        items.append(step)
    }
}
