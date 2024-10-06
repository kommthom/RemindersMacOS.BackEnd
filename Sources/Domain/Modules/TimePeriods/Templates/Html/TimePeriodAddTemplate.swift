//
//  TimePeriodAddTemplate.swift
//
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Vapor
import SwiftHtml

struct TimePeriodAddTemplate: TemplateRepresentable {
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Add A New Timeperiod")
            }
            Body {
                H1("Add A New Timeperiod")
                Form {
                    Input().type(.hidden).name("timePeriodId").value("")
                    Table {
                        Tr {
                            Td { Label("New Timeperiod Type:").for("timeperiodtype") }
                            Td {
                                Input().type(.text).list("timeperiodtypes").name("timeperiodtype").value("none")
                                Datalist {
                                    Option("normalWorkingTime")
                                    Option("normalLeisureTime")
                                    Option("sleepingTime")
                                    Option("eventTime")
                                    Option("extraWorkingTime")
                                    Option("extraLeisureTime")
                                    Option("none")
                                }
                                .id("timeperiodtypes")
                                //.attribute("id", "scopes")
                            }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("From:").for("from") }
                            Td { Input().type(.text).name("from").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("To:").for("to") }
                            Td { Input().type(.text).name("to").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Day:").for("day") }
                            Td { Input().type(.text).name("day").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button("Save")
                                    .type(.submit)
                                    .name("submit")
                                    .formaction("/timeperiods/save")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("save-timeperiod-form")
                Br()
                A("List all timeperiods").name("list-all-timeperiods").href("/timeperiods/index")
                Br()
                A("Home").name("home").href("/")
            }
        }
        .lang("en-US")
    }
}
