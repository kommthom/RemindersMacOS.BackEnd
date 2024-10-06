//
//  TaskAddTemplate.swift
//
//
//  Created by Thomas Benninghaus on 14.02.24.
//

import Vapor
import SwiftHtml

struct TaskAddTemplate: TemplateRepresentable {
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Add A New Task")
            }
            Body {
                H1("Add A New Task")
                Form {
                    Input().type(.hidden).name("taskId").value("")
                    Table {
                        Tr {
                            Td { Label("Task ID:").for("name") }
                            Td { Input().type(.text).name("name").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Description:").for("description") }
                            Td { Input().type(.text).name("description").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Title:").for("title") }
                            Td { Input().type(.text).name("title").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Due Date:").for("duedate") }
                            Td { Input().type(.text).name("duedate").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Priority:").for("priority") }
                            Td {
                                Input().type(.text).list("priorities").name("priority").value("none")
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
                            Td { Input().type(.checkbox).name("completed").checked(false) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Homepage:").for("homepage") }
                            Td { Input().type(.text).name("homepage").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Fun Points:").for("funpoints") }
                            Td { Input().type(.number).name("funpoints").value(String("0")) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Duty Points:").for("dutypoints") }
                            Td { Input().type(.number).name("dutypoints").value(String("0")) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Duration:").for("duration") }
                            Td { Input().type(.number).name("duration").value("0") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Calendar Event?:").for("calendarevent") }
                            Td { Input().type(.checkbox).name("calendarevent").checked(false) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Break after:").for("breakafter") }
                            Td { Input().type(.number).name("breakafter").value(String("0")) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Archived Path:").for("archivedpath") }
                            Td { Input().type(.number).name("archivedpath").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button("Save")
                                    .type(.submit)
                                    .name("submit")
                                    .formaction("/settings/save")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("save-task-form")
                Br()
                A("List all tasks").name("list-all-tasks").href("/tasks/index")
                Br()
                A("Home").name("home").href("/")
            }
        }
        .lang("en-US")
    }
}

