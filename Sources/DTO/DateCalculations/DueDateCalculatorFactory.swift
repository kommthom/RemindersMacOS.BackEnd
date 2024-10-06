//
//  DueDateCalculatorFactory.swift
//
//
//  Created by Thomas Benninghaus on 05.04.24.
//

import Foundation

public struct DueDateCalculatorFactory {
    public static func createWithLoop(firstArgs: DueDateCalculatorArguments) -> DueDateCalculatorProtocol? {
        var calculatorType: DateComponent? = firstArgs.type
        repeat {
            let newArgs = DueDateCalculatorArguments(type: calculatorType!, json: firstArgs.json, dateComponentInterval: nil)
            if let calculator = DueDateCalculatorFactory.create(args: newArgs) { return calculator }
            calculatorType = calculatorType!.nextCalculatorComponent()
        } while calculatorType != nil
        return nil
    }
    
    public static func create(args: DueDateCalculatorArguments) -> DueDateCalculatorProtocol? {
        return switch args.type {
            case .year: YearCalculator(args: args)
            case .quarter, .month: MonthCalculator(args: args)
            case .week: WeekCalculator(args: args)
            case .day: DayCalculator(args: args)
            case .hour, .quarterHour: TimeCalculator(args: args)
        }
    }
}
