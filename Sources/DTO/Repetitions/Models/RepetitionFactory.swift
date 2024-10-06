//
//  RepetitionFactory.swift
//
//
//  Created by Thomas Benninghaus on 26.04.24.
//

import Foundation

public struct RepetitionFactory {
    private var findKeyWord: (KeyWords.LocalizationIdentifier, String) -> KeyWord?
    private var findLocalization: (Localizations.LocalizationIdentifier, String) -> String?
    
    public init(
        findKeyWord: @escaping (KeyWords.LocalizationIdentifier, String) -> KeyWord?,
        findLocalization: @escaping(Localizations.LocalizationIdentifier, String) -> String?
    ) {
        self.findKeyWord = findKeyWord
        self.findLocalization = findLocalization
    }
    
    public func create(
        id: UUID?, 
        taskId: UUID,
        repetitionText: String,
        notificationType: NotificationType?,
        timePeriods: TimePeriodsDTO,
        findKeyWord: @escaping (KeyWords.LocalizationIdentifier, String) -> KeyWord?
    ) -> RepetitionDTO? {
        //guard parsedComponents?.ready ?? false else { return nil }
        /*guard let repetition = TextParserFactory().createComposite(typeOfParser: .composite(findKeyWord: findKeyWord))?
            .parse(input: ParsedComponent(stringValue: repetitionText)).parsedValue?.unwrap
            .rawRepetition
        else { return nil }*/
        guard let newDate = DueDateCalculatorFactory
            .createWithLoop(firstArgs: DueDateCalculatorArguments(type: .year, json: repetition.repetitionJSON, dateComponentInterval: nil, everyExternal: repetition.repetitionNumber, timePeriodsCheck: TimePeriodChecker(timePeriods: timePeriods).checkPeriods))?
            .calculate(Date.today)
        else { return nil }
        return RepetitionDTO(id: id, iteration: 1, dueDate: newDate, fromDone: repetition.fromDone, repetitionNumber: repetition.repetitionNumber, repetitionJSON: repetition.repetitionJSON, repetitionBegin: repetition.repetitionBegin, repetitionEnd: repetition.repetitionEnd, maxIterations: repetition.maxIterations, repetitionText: repetitionText, timePeriods: timePeriods, notification: notificationType, taskId: taskId)

    }
    
    public func createNext(actualRepetition: RepetitionDTO) -> RepetitionDTO? {
        guard actualRepetition.iteration < actualRepetition.maxIterations ?? Int.max else { return nil }
        let actualDate = actualRepetition.fromDone ? Date().roundedToNearestQuarterHour : actualRepetition.dueDate
        guard let newDate = DueDateCalculatorFactory
            .createWithLoop(firstArgs: DueDateCalculatorArguments(type: .year, json: actualRepetition.repetitionJSON, dateComponentInterval: nil, everyExternal: actualRepetition.repetitionNumber, timePeriodsCheck: TimePeriodChecker(timePeriods: actualRepetition.timePeriods).checkPeriods))?
            .calculate(actualDate)
        else { return nil }
        return RepetitionDTO(id: UUID(), iteration: actualRepetition.iteration + 1, dueDate: newDate, fromDone: actualRepetition.fromDone, repetitionNumber: actualRepetition.repetitionNumber, repetitionJSON: actualRepetition.repetitionJSON, repetitionBegin: actualRepetition.repetitionBegin, repetitionEnd: actualRepetition.repetitionEnd, maxIterations: actualRepetition.maxIterations, repetitionText: actualRepetition.repetitionText, timePeriods: actualRepetition.timePeriods, notification: actualRepetition.notification, taskId: actualRepetition.task_id)
    }
}
