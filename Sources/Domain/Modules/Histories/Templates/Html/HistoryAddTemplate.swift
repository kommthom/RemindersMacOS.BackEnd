//
//  HistoryAddTemplate.swift
//
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Vapor
import SwiftHtml

struct HistoryAddTemplate: TemplateRepresentable {
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Add A New Status")
            }
            Body {
                H1("Add A New Status")
                Form {
                    Input().type(.hidden).name("historyId").value("")
                    Table {
                        Tr {
                            Td { Label("History Type:").for("historytype") }
                            Td {
                                Input().type(.text).list("historytypes").name("historytype").value("begin")
                                Datalist {
                                    Option("create")
                                    Option("begin")
                                    Option("pause")
                                    Option("end")
                                    Option("archive")
                                }
                                .id("valuetypes")
                                //.attribute("id", "valuetypes")
                            }
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
