//
//  TaskShowTemplate.swift
//
//
//  Created by Thomas Benninghaus on 14.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct TaskShowTemplate: TemplateRepresentable {
    var context: TaskDTO

    init(_ context: TaskDTO) {
        self.context = context
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Show A Task")
            }
            Body {
                H1("Show A Task")
                Form {
                    Input().type(.hidden).name("taskId").value(context.id?.uuidString)
                    Table {
                        Tr {
                            Td { Label("Task ID:").for("name") }
                            Td { Tag(context.id?.uuidString).id("name") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Description:").for("description") }
                            Td { Tag(context.itemDescription).id("description") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Title:").for("title") }
                            Td { Tag(context.title).id("title") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Due Date:").for("duedate") }
                            Td { Input().type(.text).name("duedate").value(context.dueDate?.formatted()) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Priority:").for("priority") }
                            Td {
                                Input().type(.text).list("priorities").name("priority").value(context.priority.rawValue)
                                Datalist {
                                    Option("P1")
                                    Option("P2")
                                    Option("P3")
                                    Option("P4")
                                    Option("P5")
                                    Option("P6")
                                    Option("none")
                                }
                                .id("priorities")
                            }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Completed?:").for("completed") }
                            Td { Input().type(.checkbox).name("completed").checked(context.isCompleted) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Homepage:").for("homepage") }
                            Td { Input().type(.text).name("homepage").value(context.homepage) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Fun Points:").for("funpoints") }
                            Td { Input().type(.number).name("funpoints").value(String(context.funPoints)) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Duty Points:").for("dutypoints") }
                            Td { Input().type(.number).name("dutypoints").value(String(context.dutyPoints)) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Duration:").for("duration") }
                            Td { Input().type(.number).name("duration").value(String(context.duration)) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Calendar Event?:").for("calendarevent") }
                            Td { Input().type(.checkbox).name("calendarevent").checked(context.isCalendarEvent) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Break after:").for("breakafter") }
                            Td { Input().type(.number).name("breakafter").value(String(context.breakAfter)) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Archived Path:").for("archivedpath") }
                            Td { Input().type(.number).name("archivedpath").value(context.archivedPath) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button("Update")
                                    .type(.submit)
                                    .name("update")
                                    .formaction("/tasks/update")
                                    .formmethod(.post)
                                Button("Delete")
                                    .type(.submit)
                                    .name("delete")
                                    .formaction("/tasks/delete")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("show-task-form")
                Br()
                A("Home").name("home").href("/")
                Br()
                A("List all tasks").name("show-tasks").href("/tasks/index")
            }
        }
        .lang("en-US")
    }
}
