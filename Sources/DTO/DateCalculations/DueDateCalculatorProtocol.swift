//
//  DueDateCalculatorProtocol.swift
//  
//
//  Created by Thomas Benninghaus on 04.04.24.
//

import Foundation

public protocol DueDateCalculatorProtocol {
    init?(args: DueDateCalculatorArguments)
    func calculate(_ forDate: Date) -> Date
}
