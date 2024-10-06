//
//  RuleShowTemplate.swift
//  
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct RuleShowTemplate: TemplateRepresentable {
    var context: RuleDTO

    init(_ context: RuleDTO) {
        self.context = context
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Show A Rule")
            }
            Body {
                H1("Show A Rule")
                Form {
                    Input().type(.hidden).name("settingId").value(context.id?.uuidString)
                    Table {
                        Tr {
                            Td { Label("Description:").for("description") }
                            Td { Tag(context.description).id("description") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Rule Type:").for("ruletype") }
                            Td {
                                Input().type(.text).list("ruletypes").name("ruletype").value(context.ruleType.description)
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
                                Input().type(.text).list("actiontypes").name("actiontype").value(context.actionType.description)
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
                            Td { Input().type(.text).name("args").value(context.args?.joined()) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button("Update")
                                    .type(.submit)
                                    .name("update")
                                    .formaction("/rules/update")
                                    .formmethod(.post)
                                Button("Delete")
                                    .type(.submit)
                                    .name("delete")
                                    .formaction("/rules/delete")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("show-rule-form")
                Br()
                A("Home").name("home").href("/")
                Br()
                A("List all rules").name("show-rules").href("/rules/index")
            }
        }
        .lang("en-US")
    }
}
