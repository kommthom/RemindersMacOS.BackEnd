//
//  ParsedComponentsAnalyzer.swift
//
//
//  Created by Thomas Benninghaus on 15.04.24.
//

import Foundation

public struct ParsedComponentsAnalyzer: RawRepresentable {
    public typealias RawValue = ParsedComponents
    
    public var rawValue: ParsedComponents
    private var componentsSet: TransformedComponents
    
    public init?(rawValue: ParsedComponents) {
        guard rawValue.components.count > 0  else { return nil }
        guard let componentsSet = ParsedComponentsAnalyzer.transform(parsedComponents: rawValue) else { return nil }
        self.rawValue = rawValue
        self.componentsSet = TransformedComponents(transformedComponents: componentsSet)
    }
    
    public init?(rawValue: ParsedComponent) {
        switch rawValue.parsedValue {
            case .composite(let rawValues): self.init(rawValue: rawValues)
            default: return nil
        }
    }
    
    public func buildRawRepetition() -> RepetitionFromParse {
        return RepetitionFromParse(
            iteration: 1,
            fromDone: componentsSet.first(matching: .isOfType(transformedComponentType: .fromDone))?.fromDone ?? false,
            repetitionNumber: componentsSet.first(matching: .isOfType(transformedComponentType: .repetitionNumber))?.child?.every ?? 1,
            repetitionJSON: componentsSet.makeDateComponentInterval(transformedComponentType: .repetitionJSON)?.rawValue ?? "",
            repetitionBegin: componentsSet.first(matching: .isOfType(transformedComponentType: .repetitionBegin))?.child?.dateRelativeList?.items.first?.date,
            repetitionEnd: componentsSet.first(matching: .isOfType(transformedComponentType: .repetitionEnd))?.child?.dateRelativeList?.items.first?.date,
            maxIterations: componentsSet.first(matching: .isOfType(transformedComponentType: .maxIterations))?.child?.every)
    }
    
    private static func transform(parsedComponents: ParsedComponents) -> Set<TransformedComponent>? {
        var components: AnalyzedComponents = AnalyzedComponents()
        return Set(parsedComponents.components
            .enumerated()
            .filter { (index: Int, component: ParsedComponent) in
                component.ready }
            .compactMap { (index: Int, component: ParsedComponent) in
                switch component.parsedValue {
                    case .keyword(let keyword):
                        switch keyword.keyWordType {
                            case .repeating(let fromDone):
                                let _ = components.stepsAppend(.keywordRepeatingFound)
                                        .createOrUpdate(type: .fromDone,
                                                        create: { TransformedComponent(transformedComponentType: .fromDone, fromDone: fromDone, parsedComponentsIndices: [index], successState: .fromDoneCreated ) } )
                                        .createOrUpdate(type: .repetitionNumber, 
                                                        create: { TransformedComponent(transformedComponentType: .repetitionNumber, parsedComponentsIndices: [index], child: DateComponentInterval(listType: .every), successState: .createNewRepeatingComponent ) })
                                        .releaseAndCreateOrUpdate(type: .repetition,
                                                        create: { TransformedComponent(transformedComponentType: .repetitionJSON, index: index, successState: .createDefaultRepeatingComponent) } )
                            case .dateTimeSpan(let dateComponent): //set calculator type
                                if !(components.repetitionNumber?.releasable ?? false) {
                                    let _ = components.createOrUpdate(type: .repetitionNumber,
                                                        create: { TransformedComponent(transformedComponentType: .repetitionNumber, index: index, every: 1, component: dateComponent, successState: .createNewRepeatingComponent) },
                                                        condition: { component in component.child?.component == nil },
                                                        updateElse: { component in component.setComponentType(index: index, component: dateComponent) } )
                                }
                                let _ = components.stepsAppend(.keywordDateTimeSpanFound)
                                        .releaseAndCreateOrUpdate(type: .repetition,
                                                        create: { TransformedComponent(transformedComponentType: .repetitionJSON, index: index, every: 1, component: dateComponent, successState: .createNewRepeatingComponent) } ,
                                                        condition: { component in component.releasable },
                                                        update: { component in component.setComponentType(index: index, component: dateComponent) } )
                            case .typeOfDay(let type):
                                let _ = components.stepsAppend(.keywordTypeOfDayFound)
                                        .releaseAndCreateOrUpdate(type: .repetition,
                                                        create: { TransformedComponent(transformedComponentType: .repetitionJSON, index: index, every: 1, typeOfDay: type, successState: .createNewTypedDayComponent) } ,
                                                        condition: { component in component.releasable && component.child?.component != .day },
                                                        update: { component in component.appendTypedDay(index: index, every: 1, typeOfDay: type) } )
                            case .timeOfDay(let time):
                                let _ = components.stepsAppend(.keywordTimeOfDayFound)
                                        .releaseAndCreateOrUpdate(type: .repetition,
                                                        create: { TransformedComponent(transformedComponentType: .repetitionJSON, index: index, fixedDate: time == .keyWord ? nil : time.dateValue!, formatType: .hhmm, successState: .createNewTimeComponent) } ,
                                                        condition: { component in component.releasable && component.child?.component != .hour && component.child?.component != .quarterHour },
                                                        update: { component in time == .keyWord ? component.appendIndex(index: index) : component.appendDate(index: index, fixedDate: time.dateValue!, formatType: .hhmm) } )
                            case .intName(let value):
                                if components.current?.transformedComponentType == .maxIterations || parsedComponents.components[index + 1].parsedValue[keyPath: \.?.keyword] == .times {
                                    let _ = components.stepsAppend(.keywordIntNameFound)
                                        .releaseAndCreateOrUpdate(type: .repetition,
                                                        create: { TransformedComponent(transformedComponentType: .maxIterations, index: index, every: value, successState: .createNewRepeatingComponent) } ,
                                                        condition: { component in component.releasable },
                                                        update: { component in component.setRepetitionNo(index: index, every: value) } )
                                } else {
                                    let _ = components.stepsAppend(.keywordIntNameFound)
                                        .createOrUpdate(type: .repetitionNumber,
                                                        create: { TransformedComponent(transformedComponentType: .repetitionNumber, index: index, every: value, successState: .repetitionNumberCompleted) },
                                                        condition: { component in component.child?.every != nil },
                                                        updateElse: { component in component.setRepetitionNo(index: index, every: value) } )
                                        .releaseAndCreateOrUpdate(type: .repetition,
                                                        create: { TransformedComponent(transformedComponentType: .repetitionJSON, index: index, every: value, successState: .createNewRepeatingComponent) } ,
                                                        condition: { component in component.releasable },
                                                        update: { component in component.setRepetitionNo(index: index, every: value) } )
                                }
                            case .interval(let type):
                                switch type {
                                    case .starting:
                                        let _ = components.stepsAppend(.keywordRepetitionStartingFound)
                                            .releaseAndCreateOrUpdate(type: .repetitionBegin,
                                                        create: { TransformedComponent(index: index, fixedDate: nil, successState: .repetitionStartingInitialized) } ,
                                                        condition: { component in component.releasable } )
                                    case .ending:
                                        let _ = components.stepsAppend(.keywordRepetitionEndingFound)
                                            .releaseAndCreateOrUpdate(type: .repetitionEnd,
                                                        create: { TransformedComponent(index: index, fixedDate: nil, successState: .repetitionEndingInitialized) } ,
                                                        condition: { component in component.releasable } )
                                    case .length:
                                        let _ = components.stepsAppend(.keywordMaxIterationsFound)
                                            .releaseAndCreateOrUpdate(type: .maxIterations,
                                                        create: { TransformedComponent(index: index, fixedDate: nil, successState: .maxIterationsInitialized) } ,
                                                        condition: { component in component.releasable } )
                                }
                            case .dateInit:
                                    let _ = components.stepsAppend(.keywordDateInitFound)
                                        .createOrUpdate(type: .repetitionNumber,
                                                        create: { TransformedComponent(transformedComponentType: .repetitionNumber, parsedComponentsIndices: [index], child: DateComponentInterval(component: .day, listType: .fixed, every: 1), successState: .createNewDateInitComponent ) } )
                                        .releaseAndCreateOrUpdate(type: .repetition,
                                                        create: { TransformedComponent(parsedComponentsIndices: [index], child: DateComponentInterval(component: .day, listType: .fixed, every: 1), successState: .createNewDateInitComponent ) } )
                            case .listSeparator:
                                let _ = components.stepsAppend(.listSeparatorFound)
                                        .stepsAppend((components.current?.appendIndex(index: index, successState: .repetitionListSeparatorAdded).state)!)
                            case .filler: let _ = 0
                        }
                    case .int(let value):
                        if components.current?.transformedComponentType == .maxIterations || parsedComponents.components[index + 1].parsedValue[keyPath: \.?.keyword] == .times {
                            let _ = components.stepsAppend(.keywordIntNameFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(transformedComponentType: .maxIterations, index: index, every: value, successState: .createNewRepeatingComponent) } ,
                                                condition: { component in component.releasable },
                                                update: { component in component.setRepetitionNo(index: index, every: value) } )
                        } else {
                            let _ = components.stepsAppend(.keywordIntNameFound)
                                .createOrUpdate(type: .repetitionNumber,
                                                create: { TransformedComponent(transformedComponentType: .repetitionNumber, index: index, every: value, successState: .repetitionNumberCompleted) },
                                                condition: { component in component.child?.every != nil },
                                                updateElse: { component in component.setRepetitionNo(index: index, every: value) } )
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(transformedComponentType: .repetitionJSON, index: index, every: value, successState: .createNewRepeatingComponent) } ,
                                                condition: { component in component.releasable },
                                                update: { component in component.setRepetitionNo(index: index, every: value) } )
                        }
                    case .day(let date):
                        if components.current?.transformedComponentType == .repetitionBegin {
                            let _ = components.stepsAppend(.dateValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(transformedComponentType: .repetitionBegin, index: index, fixedDate: Date.today.nextMonthDay(dayOfMonth: date.day).dateInTimeZone, formatType: .dd, successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable },
                                                update: { component in component.appendDate(index: index, fixedDate: Date.today.nextMonthDay(dayOfMonth: date.day), formatType: .dd) } )
                        } else if components.current?.transformedComponentType == .repetitionEnd {
                            let _ = components.stepsAppend(.dateValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(transformedComponentType: .repetitionEnd, index: index, fixedDate: Date.today.nextMonthDay(dayOfMonth: date.day), formatType: .dd, successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable },
                                                update: { component in component.appendDate(index: index, fixedDate: Date.today.nextMonthDay(dayOfMonth: date.day).dateInTimeZone, formatType: .dd) } )
                        } else {
                            let _ = components.stepsAppend(.dateValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(transformedComponentType: .repetitionJSON, index: index, fixedDate: date, formatType: .dd, successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable && component.state != .repetitionListSeparatorAdded},
                                                update: { component in component.appendDate(index: index, fixedDate: date, formatType: .dd) } )
                        }
                    case .time(let date):
                        let _ = components.stepsAppend(.timeValueFound)
                                        .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(transformedComponentType: .repetitionJSON, index: index, fixedDate: date, formatType: .hhmm, successState: .createNewTimeComponent) } ,
                                                condition: { component in component.releasable && component.child?.component != .hour && component.child?.component != .quarterHour },
                                                update: { component in component.appendDate(index: index, fixedDate: date, formatType: .hhmm) } )
                    case .monthDay(let month, let day):
                        if components.current?.transformedComponentType == .repetitionBegin {
                            let _ = components.stepsAppend(.dateValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(transformedComponentType: .repetitionBegin, index: index, fixedDate: DateRelative(year: Date.today.year, month: month, day: day, dayType: .ofMonth), successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable },
                                                update: { component in component.appendDayMonthYear(index: index, fixedDate: DateRelative(year: Date.today.year, month: month, day: day, dayType: .ofMonth)) } )
                        } else if components.current?.transformedComponentType == .repetitionEnd {
                            let _ = components.stepsAppend(.dateValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(transformedComponentType: .repetitionEnd, index: index, fixedDate: DateRelative(year: Date.today.year, month: month, day: day, dayType: .ofMonth), successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable },
                                                update: { component in component.appendDayMonthYear(index: index, fixedDate: DateRelative(year: Date.today.year, month: month, day: day, dayType: .ofMonth)) } )
                        } else {
                            let _ = components.stepsAppend(.dateComponentValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(index: index, fixedDate: DateRelative(month: month, day: day, dayType: .ofMonth), successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable && component.state != .repetitionListSeparatorAdded},
                                                update: { component in component.appendDayMonthYear(index: index, fixedDate: DateRelative(month: month, day: day, dayType: .ofMonth)) } )
                        }
                    case .month(let month):
                        if components.current?.transformedComponentType == .repetitionBegin {
                            let _ = components.stepsAppend(.dateValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(transformedComponentType: .repetitionBegin, index: index, fixedDate: DateRelative(year: Date.today.year, month: month, day: 99, dayType: .ofMonth, dayFilter: .ultimo), successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable },
                                                update: { component in component.appendDayMonthYear(index: index, fixedDate: DateRelative(year: Date.today.year, month: month, day: 99, dayType: .ofMonth, dayFilter: .ultimo)) } )
                        } else if components.current?.transformedComponentType == .repetitionEnd {
                            let _ = components.stepsAppend(.dateValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(transformedComponentType: .repetitionEnd, index: index, fixedDate: DateRelative(year: Date.today.year, month: month, day: 99, dayType: .ofMonth, dayFilter: .ultimo), successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable },
                                                update: { component in component.appendDayMonthYear(index: index, fixedDate: DateRelative(year: Date.today.year, month: month, day: 99, dayType: .ofMonth, dayFilter: .ultimo)) } )
                        } else {
                            let _ = components.stepsAppend(.dateComponentValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(index: index, fixedDate: DateRelative(month: month), successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable && component.state != .repetitionListSeparatorAdded},
                                                update: { component in component.appendDayMonthYear(index: index, fixedDate: DateRelative(month: month)) } )
                        }
                    case .weekday(let weekday):
                        let _ = components.stepsAppend(.weekdayFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(index: index, fixedDate: DateRelative(day: weekday.index, dayType: .ofWeek), successState: .createNewWeekdayComponent) } ,
                                                condition: { component in component.releasable && component.state != .repetitionListSeparatorAdded},
                                                update: { component in component.appendDayMonthYear(index: index, fixedDate: DateRelative(day: weekday.index, dayType: .ofWeek)) } )
                    case .year(let year):
                        if components.current?.transformedComponentType == .repetitionBegin {
                            let _ = components.stepsAppend(.dateValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(transformedComponentType: .repetitionBegin, index: index, fixedDate: DateRelative(year: year, day: 999, dayType: .ofYear, dayFilter: .yearsEnd), successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable },
                                                update: { component in component.appendDayMonthYear(index: index, fixedDate: DateRelative(year: year, day: 999, dayType: .ofYear, dayFilter: .yearsEnd)) } )
                        } else if components.current?.transformedComponentType == .repetitionEnd {
                            let _ = components.stepsAppend(.dateValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(transformedComponentType: .repetitionEnd, index: index, fixedDate: DateRelative(year: year, day: 999, dayType: .ofYear, dayFilter: .yearsEnd), successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable },
                                                update: { component in component.appendDayMonthYear(index: index, fixedDate: DateRelative(year: year, day: 999, dayType: .ofYear, dayFilter: .yearsEnd)) } )
                        } else {
                            let _ = components.releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(index: index, fixedDate: DateRelative(year: year)) } ,
                                                condition: { component in component.releasable && component.state != .repetitionListSeparatorAdded},
                                                update: { component in component.appendDayMonthYear(index: index, fixedDate: DateRelative(year: year)) } )
                        }
                    case .yearMonth(let year, let month):
                        if components.current?.transformedComponentType == .repetitionBegin {
                            let _ = components.stepsAppend(.dateValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                          create: { TransformedComponent(transformedComponentType: .repetitionBegin, index: index, fixedDate: DateRelative(year: year, month: month, day: 99, dayType: .ofMonth, dayFilter: .ultimo), successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable },
                                                update: { component in component.appendDayMonthYear(index: index, fixedDate: DateRelative(year: year, month: month, day: 99, dayType: .ofMonth, dayFilter: .ultimo)) } )
                        } else if components.current?.transformedComponentType == .repetitionEnd {
                            let _ = components.stepsAppend(.dateValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(transformedComponentType: .repetitionEnd, index: index, fixedDate: DateRelative(year: year, month: month, day: 99, dayType: .ofMonth, dayFilter: .ultimo), successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable },
                                                update: { component in component.appendDayMonthYear(index: index, fixedDate: DateRelative(year: year, month: month, day: 99, dayType: .ofMonth, dayFilter: .ultimo)) } )
                        } else {
                            let _ = components.stepsAppend(.dateComponentValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(index: index, fixedDate: DateRelative(year: year, month: month), successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable && component.state != .repetitionListSeparatorAdded},
                                                update: { component in component.appendDayMonthYear(index: index, fixedDate: DateRelative(year: year, month: month)) } )
                        }
                    case .yearMonthDay(let year, let month, let day):
                        if components.current?.transformedComponentType == .repetitionBegin {
                            let _ = components.stepsAppend(.dateValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(transformedComponentType: .repetitionBegin, index: index, fixedDate: DateRelative(year: year, day: day, dayType: .ofMonth), successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable },
                                                update: { component in component.appendDayMonthYear(index: index, fixedDate: DateRelative(year: year, day: day, dayType: .ofMonth)) } )
                        } else if components.current?.transformedComponentType == .repetitionEnd {
                            let _ = components.stepsAppend(.dateValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(transformedComponentType: .repetitionEnd, index: index, fixedDate: DateRelative(year: year, day: day, dayType: .ofMonth), successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable },
                                                update: { component in component.appendDayMonthYear(index: index, fixedDate: DateRelative(year: year, day: day, dayType: .ofMonth)) } )
                        } else {
                            let _ = components.stepsAppend(.dateComponentValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(index: index, fixedDate: DateRelative(year: year, month: month, day: day, dayType: .ofMonth), successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable && component.state != .repetitionListSeparatorAdded},
                                                update: { component in component.appendDayMonthYear(index: index, fixedDate: DateRelative(year: year, month: month, day: day, dayType: .ofMonth)) } )
                        }
                    case .dateRelative(let dateRelative):
                        if components.current?.transformedComponentType == .repetitionBegin {
                            let _ = components.stepsAppend(.dateValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                          create: { TransformedComponent(transformedComponentType: .repetitionBegin, index: index, fixedDate: dateRelative.completeDate(), successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable },
                                                          update: { component in component.appendDayMonthYear(index: index, fixedDate: dateRelative.completeDate()) } )
                        } else if components.current?.transformedComponentType == .repetitionEnd {
                            let _ = components.stepsAppend(.dateValueFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                          create: { TransformedComponent(transformedComponentType: .repetitionEnd, index: index, fixedDate: dateRelative.completeDate(replaceNilBy: Date.distantFuture), successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable },
                                                          update: { component in component.appendDayMonthYear(index: index, fixedDate: dateRelative.completeDate(replaceNilBy: Date.distantFuture)) } )
                        } else {
                            let _ = components.stepsAppend(.dateRelativeFound)
                                .releaseAndCreateOrUpdate(type: .repetition,
                                                create: { TransformedComponent(index: index, fixedDate: dateRelative, successState: .createNewDateComponent) } ,
                                                condition: { component in component.releasable && component.state != .repetitionListSeparatorAdded},
                                                update: { component in component.appendDayMonthYear(index: index, fixedDate: dateRelative) } )
                        }
                    case .composite(_): let _ = index // do nothing
                    //case .repetitionArgument(_): let _ = index
                    case .other(_): let _ = index
                    case .none: let _ = index
                }
                if index + 1 == parsedComponents.components.count {
                    if components.repetitionNumber == nil { components.repetitionNumber = TransformedComponent(transformedComponentType: .repetitionNumber, intValue: 1, successState: .createNewRepeatingComponent) }
                    if components.fromDone == nil { components.fromDone = TransformedComponent(transformedComponentType: .fromDone, fromDone: false, successState: .fromDoneCreated) }
                }
                return components.returnValue()
            } ).union(components.getAllNotNil())
    }
}
