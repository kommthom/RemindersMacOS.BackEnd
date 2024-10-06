//
//  RemindersDataModels.swift
//
//
//  Created by Thomas Benninghaus on 27.05.24.
//

import Foundation
import DTO

public final class RemindersDataModels {
    public var basicData: BasicDataModels
    public var locale: KeyWords.LocalizationIdentifier
    public var projects: [ProjectModel]
    public var tasks: [TaskModel]
    public var repetitions: [RepetitionModel]
    public var timePeriods: [TimePeriodModel]
        
    public init(locale: KeyWords.LocalizationIdentifier, basicData models: BasicDataModels? = nil, projects: [ProjectModel]? = nil, tasks: [TaskModel]? = nil, timePeriods: [TimePeriodModel]? = nil) {
        self.basicData = models ?? BasicDataModels.mock
        self.locale = locale
        self.projects = projects ?? projectsMock
        self.tasks = tasks ?? tasksMock
    }

    private var uuids: [UUID] = [0...57].map { int in UUID()}
    
    private var projectsMock: [ProjectModel] { [
        ProjectModel(id: uuids[0], userId: basicData.users[0].1.userId, leftKey: -1, rightKey: 0, name: "\(Constants.projectsDemoProjectName) 1", color: CodableColor(wrappedValue: .green), defaultTagId: nil),
        ProjectModel(id: uuids[1], userId: basicData.users[0].1.userId, leftKey: -1, rightKey: 0, name: "\(Constants.projectsDemoProjectName) 2", color: CodableColor(wrappedValue: .blue), defaultTagId: nil)
    ] }
    private var tasksMock: [TaskModel] { [
        TaskModel(id: uuids[2], itemDescription: "\(Constants.projectsDemoTaskName) 3", title: "title: \(Constants.projectsDemoTaskName) 3", priority: Priority.none, isCompleted: false, homepage: nil, dutyPoints: 2, funPoints: 0, duration: 2.0, isCalendarEvent: false, breakAfter: 2.0, archivedPath: nil, parentItemId: nil, projectId: uuids[0]),
        TaskModel(id: uuids[3], itemDescription: "\(Constants.projectsDemoTaskName) 4", title: "title: \(Constants.projectsDemoTaskName) 4", priority: .P2, isCompleted: false, homepage: "https://google.com", dutyPoints: 0, funPoints: 2, duration: 0.25, isCalendarEvent: false, breakAfter: 2.0, archivedPath: nil, parentItemId: nil, projectId: uuids[1]),
        TaskModel(id: uuids[4], itemDescription: "\(Constants.projectsDemoTaskName) 5", title: "title: \(Constants.projectsDemoTaskName) 5", priority: .P6, isCompleted: false, homepage: "https://hello.world", dutyPoints: 3, funPoints: 0, duration: 0.25, isCalendarEvent: false, breakAfter: 0.25, archivedPath: nil, parentItemId: nil, projectId: uuids[1]),
        TaskModel(id: uuids[5], itemDescription: "\(Constants.projectsDemoTaskName) 0", title: "title: \(Constants.projectsDemoTaskName) 0", priority: .P4, isCompleted: false, homepage: nil, dutyPoints: 1, funPoints: 1, duration: 1.5, isCalendarEvent: false, breakAfter: 2.0, archivedPath: nil, parentItemId: nil,  projectId: basicData.users[0].1.userId),
        TaskModel(id: uuids[6], itemDescription: "\(Constants.projectsDemoTaskName) 1", title: "title: \(Constants.projectsDemoTaskName) 1", priority: Priority.none, isCompleted: false, homepage: "https://hello.world", dutyPoints: 0, funPoints: 5, duration: 1.0, isCalendarEvent: false, archivedPath: nil, parentItemId: nil, projectId: basicData.users[0].1.userId),
        TaskModel(id: uuids[7], itemDescription: "\(Constants.projectsDemoTaskName) 2", title: "title: \(Constants.projectsDemoTaskName) 2", priority: .P3, isCompleted: false, homepage: "https://hello.world", dutyPoints: 10, funPoints: 0, duration: 0.5, isCalendarEvent: false, archivedPath: nil, parentItemId: nil,  projectId: basicData.users[0].1.userId)
    ] }
    private var repetitionsMock: [RepetitionModel] { 
        let factory = RepetitionFactory(locale: locale)
        let tpDTO: TimePeriodsDTO = TimePeriodsDTO(many: timePeriods)
        return [
            RepetitionModel(from: factory.create(id: UUID(), taskId: uuids[2], repetitionText: "jede! 2. woche freitags stündlich bis 30.06.2024", timePeriods: tpDTO)!),
            RepetitionModel(from: factory.create(id: UUID(), taskId: uuids[3], repetitionText: "jeden! montag viertelstündlich", timePeriods: tpDTO)!),
            RepetitionModel(from: factory.create(id: UUID(), taskId: uuids[5], repetitionText: "jedes jahr jede 20. woche jeden Mittwoch 19:15 max 2", timePeriods: [])!),
            RepetitionModel(from: factory.create(id: UUID(), taskId: uuids[7], repetitionText: "jeden! 2. ultimo ab 30.06.2024", timePeriods: tpDTO)!)
        ]
    }
    private var timePeriodsMock: [TimePeriodModel] {
    case 1:
        let newTimePeriod = TimePeriodModel(id: UUID(), typeOfTime: .individual, from: "16:00", to: "18:00", day: nil, parentId: nil, for: userId)
        return self
            .find(userId: userId, typeOfTime: .individual, from: newTimePeriod.from, to: newTimePeriod.to)
            .flatMap { timePeriod in
                if let _ = timePeriod { return database.eventLoop.makeSucceededFuture([timePeriod!]) }
                return self
                    .create(newTimePeriod)
                    .map { return [newTimePeriod] }
            }
    case 2, 3, 4: return database.eventLoop.makeSucceededFuture([])
    case 5: return self.getByTypes(userId: userId, typesOfTime: [.normalLeisureTimeWE, .normalWorkingTime])
    default: return self.getByTypes(userId: userId, typesOfTime: [.normalWorkingTime])
    }
        
    /*public init?(id: UUID?, taskId: UUID, repetitionText: String, timePeriods: TimePeriodsDTO, notification: NotificationType?, locale: LocaleIdentifier) {
        let parser = TextParserFactory(locale: locale).createComposite(typeOfParser: ParsableComponentType.composite)
        let parsedComponents = parser?.parse(input: ParsedComponent(stringValue: repetitionText))
        guard parsedComponents?.ready ?? false else { return nil }
        self.init(id: id, iteration: 1, dueDate: Date.today, fromDone: true, repetitionNumber: 1, repetitionJSON: nil, repetitionBegin: nil, repetitionEnd: nil, maxIterations: 2, repetitionText: "", timePeriods: timePeriods, notification: notification, taskId: taskId)
    }*/
}
