//
//  ProjectShowTemplate.swift
//  
//
//  Created by Thomas Benninghaus on 11.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct ProjectShowTemplate: TemplateRepresentable {
    var context: ProjectDTO

    init(_ context: ProjectDTO) {
        self.context = context
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Show A Project")
            }
            Body {
                H1("Show A Project")
                Form {
                    Input().type(.hidden).name("projectId").value(context.id?.uuidString)
                    Table {
                        Tr {
                            Td { Label("Project ID:").for("name") }
                            Td { Tag(context.id?.uuidString).id("name") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Left Key:").for("leftkey") }
                            Td { Input().type(.number).name("leftkey").value(String(context.leftKey)) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Right Key:").for("rightkey") }
                            Td { Input().type(.number).name("rightkey").value(String(context.rightKey)) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Project Name:").for("name") }
                            Td { Tag(context.name).id("name") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Completed?:").for("iscompleted") }
                            Td { Input().type(.text).name("iscompleted").value(String(context.isCompleted)) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Level:").for("level") }
                            Td { Input().type(.text).name("level").value(String(context.level)) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Path:").for("path") }
                            Td { Input().type(.text).name("path").value(context.path) }
                        }.style("background-color: #F0F0FF")

                        Tr {
                            Td {
                                Button("Update")
                                    .type(.submit)
                                    .name("update")
                                    .formaction("/projects/update")
                                    .formmethod(.post)
                                Button("Delete")
                                    .type(.submit)
                                    .name("delete")
                                    .formaction("/projects/delete")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("show-project-form")
                Br()
                A("Home").name("home").href("/")
                Br()
                A("List all projects").name("show-projects").href("/projects/index")
            }
        }
        .lang("en-US")
    }
}
