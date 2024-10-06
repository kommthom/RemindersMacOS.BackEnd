//
//  HistoryShowTemplate.swift
//  
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct HistoryShowTemplate: TemplateRepresentable {
    var context: HistoryDTO

    init(_ context: HistoryDTO) {
        self.context = context
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Show A Status")
            }
            Body {
                H1("Show A Status")
                Form {
                    Input().type(.hidden).name("settingId").value(context.id?.uuidString)
                    Table {
                        Tr {
                            Td { Label("Setting ID:").for("name") }
                            Td { Tag(context.id?.uuidString).id("name") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Timestamp:").for("timestamp") }
                            Td { Input().type(.number).name("timestamp").value(context.timestamp?.formatted()) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("History Type:").for("historytype") }
                            Td {
                                Input().type(.text).list("historytypes").name("historytype").value(context.historyType.rawValue)
                                Datalist {
                                    Option("create")
                                    Option("begin")
                                    Option("pause")
                                    Option("end")
                                    Option("archive")
                                }
                                .id("valuetypes")
                            }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button("Update")
                                    .type(.submit)
                                    .name("update")
                                    .formaction("/settings/update")
                                    .formmethod(.post)
                                Button("Delete")
                                    .type(.submit)
                                    .name("delete")
                                    .formaction("/settings/delete")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("show-setting-form")
                Br()
                A("Home").name("home").href("/")
                Br()
                A("List all settings").name("show-settings").href("/settings/index")
            }
        }
        .lang("en-US")
    }
}
