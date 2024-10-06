//
//  RuleAddTemplate.swift
//
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Vapor
import SwiftHtml

struct RuleAddTemplate: TemplateRepresentable {
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Add A New Rule")
            }
            Body {
                H1("Add A New Rule")
                Form {
                    Input().type(.hidden).name("ruleId").value("")
                    Table {
                        Tr {
                            Td { Label("Description:").for("description") }
                            Td { Input().type(.number).name("description").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Rule Type:").for("ruletype") }
                            Td {
                                Input().type(.text).list("ruletypes").name("ruletype").value("none")
                                Datalist {
                                    Option("On_Start")
                                    Option("On_End")
                                    Option("On_Break")
                                    Option("none")
                                }
                                .id("ruletypes")
                                //.attribute("id", "scopes")
                            }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Action Type:").for("actiontype") }
                            Td {
                                Input().type(.text).list("actiontypes").name("actiontype").value("Archive")
                                Datalist {
                                    Option("Archive")
                                    Option("Open_Mail")
                                    Option("Open_Calendar")
                                    Option("Open_Music")
                                    Option("Create_Task")
                                    Option("Load_MetalHammer")
                                }
                                .id("actiontypes")
                                //.attribute("id", "valuetypes")
                            }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Arguments:").for("args") }
                            Td { Input().type(.text).name("args").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button("Save")
                                    .type(.submit)
                                    .name("submit")
                                    .formaction("/rules/save")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("save-rule-form")
                Br()
                A("List all rules").name("list-all-rules").href("/rules/index")
                Br()
                A("Home").name("home").href("/")
            }
        }
        .lang("en-US")
    }
}
