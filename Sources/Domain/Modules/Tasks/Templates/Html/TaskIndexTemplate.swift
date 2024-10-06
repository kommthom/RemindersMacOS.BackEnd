//
//  TaskIndexTemplate.swift
//  
//
//  Created by Thomas Benninghaus on 14.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct TaskIndexTemplate: TemplateRepresentable {
    var context: TasksDTO

    init(_ tasksContext: TasksDTO) {
        self.context = tasksContext
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("List All Tasks")
            }
            Body {
                H1("List All Tasks")
                Table {
                    Tr {
                        Td("Note: Update and Delete are accesible thru Show.")
                    }
                    Tr { Td() }
                    Tr {
                        Th("Description").style("text-align:left")
                        Th("Title").style("text-align:left")
                        Th("Due Date").style("text-align:left")
                        Th("Priority").style("text-align:left")
                        Th("Completed?").style("text-align:left")
                        Th("Homepage").style("text-align:left")
                        Th("Fun Points").style("text-align:left")
                        Th("Duty Points").style("text-align:left")
                        Th("Duration").style("text-align:left")
                        Th("Calendar Event?").style("text-align:left")
                        Th("Break after").style("text-align:left")
                        Th("Archived Path").style("text-align:left")
                    }
                    for taskContext in context.tasks {
                        Tr {
                            Td(taskContext.itemDescription)
                            Td(taskContext.title)
                            Td(taskContext.dueDate?.formatted())
                            Td(taskContext.priority.rawValue)
                            Td(String(taskContext.isCompleted))
                            Td(taskContext.homepage)
                            Td(String(taskContext.funPoints))
                            Td(String(taskContext.dutyPoints))
                            Td(String(taskContext.duration))
                            Td(String(taskContext.isCalendarEvent))
                            Td(String(taskContext.breakAfter))
                            Td(taskContext.archivedPath)

                            Td { A("Show").name("show-link")
                                    .href("/tasks/show?taskId=\(taskContext.id!)")
                            }
                        }.style("background-color: #F0F0FF")
                    }
                    Tr { Td() }
                }
                Br()
                A("Home").name("home").href("/")
            }
        }.lang("en-US")
    }
}
