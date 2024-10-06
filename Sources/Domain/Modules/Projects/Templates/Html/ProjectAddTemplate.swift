//
//  ProjectAddTemplate.swift
//  
//
//  Created by Thomas Benninghaus on 11.02.24.
//

import Vapor
import SwiftHtml

struct ProjectAddTemplate: TemplateRepresentable {
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Add A New Project")
            }
            Body {
                H1("Add A New Project")
                Form {
                    Input().type(.hidden).name("projectId").value("")
                    Table {
                        Tr {
                            Td { Label("Left Key:").for("leftKey") }
                            Td { Input().type(.number).name("leftKey").value("0") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Right Key:").for("rightKey") }
                            Td { Input().type(.number).name("rightKey").value("0") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("New Project Name:").for("name") }
                            Td { Input().type(.text).name("name").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Completed?:").for("isCompleted") }
                            Td { Input().type(.checkbox).name("isCompleted").checked(false) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Level:").for("level") }
                            Td { Input().type(.number).name("level").value("0") }
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
                }.name("save-setting-form")
                Br()
                A("List all settings").name("list-all-settings").href("/settings/index")
                Br()
                A("Home").name("home").href("/")
            }
        }
        .lang("en-US")
    }
}
