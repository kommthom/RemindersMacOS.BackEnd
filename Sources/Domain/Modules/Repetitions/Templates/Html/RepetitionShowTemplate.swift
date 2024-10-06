//
//  RepetitionShowTemplate.swift
//  
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct RepetitionShowTemplate: TemplateRepresentable {
    var context: RepetitionDTO

    init(_ context: RepetitionDTO) {
        self.context = context
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Show A Setting")
            }
            Body {
                H1("Show A Setting")
                Form {
                    Input().type(.hidden).name("repetitionId").value(context.id?.uuidString)
                    Table {
                        Tr {
                            Td { Label("Repetition ID:").for("name") }
                            Td { Tag(context.id?.uuidString).id("name") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Repetition Number:").for("repetitionnumber") }
                            Td { Input().type(.number).name("repetitionnumber").value(String(context.repetitionNumber)) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Repetition JSON:").for("repetitionjson") }
                            Td { Input().type(.text).name("repetitionjson").value(context.repetitionJSON) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Repetition End:").for("repetitionend") }
                            Td { Input().type(.number).name("repetitionend").value(context.repetitionEnd?.formatted()) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Repetition Text:").for("repetitiontext") }
                            Td { Input().type(.number).name("repetitiontext").value(String(context.repetitionText)) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button("Update")
                                    .type(.submit)
                                    .name("update")
                                    .formaction("/repetitions/update")
                                    .formmethod(.post)
                                Button("Delete")
                                    .type(.submit)
                                    .name("delete")
                                    .formaction("/repetitions/delete")
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
