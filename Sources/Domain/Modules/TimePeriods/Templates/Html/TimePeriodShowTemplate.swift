//
//  TimePeriodShowTemplate.swift
//  
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct TimePeriodShowTemplate: TemplateRepresentable {
    var context: TimePeriodDTO

    init(_ context: TimePeriodDTO) {
        self.context = context
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Show A Timeperiod")
            }
            Body {
                H1("Show A Timeperiod")
                Form {
                    Input().type(.hidden).name("timePeriodId").value(context.id?.uuidString)
                    Table {
                        Tr {
                            Td { Label("Type of Time:").for("typeoftime") }
                            Td {
                                Input().type(.text).list("typeoftimes").name("typeoftime").value(context.typeOfTime.rawValue)
                                Datalist {
                                    Option("normalWorkingTime")
                                    Option("normalLeisureTime")
                                    Option("sleepingTime")
                                    Option("eventTime")
                                    Option("extraWorkingTime")
                                    Option("extraLeisureTime")
                                    Option("none")
                                }
                                .id("typeoftimes")
                            }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("From:").for("from") }
                            Td { Input().type(.text).name("from").value(context.from) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("To:").for("to") }
                            Td { Input().type(.text).name("to").value(context.to) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Day:").for("day") }
                            Td { Input().type(.number).name("day").value(context.day?.formatted()) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button("Update")
                                    .type(.submit)
                                    .name("update")
                                    .formaction("/timeperiods/update")
                                    .formmethod(.post)
                                Button("Delete")
                                    .type(.submit)
                                    .name("delete")
                                    .formaction("/timeperiods/delete")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("show-timeperiod-form")
                Br()
                A("Home").name("home").href("/")
                Br()
                A("List all timeperiods").name("show-timeperiods").href("/timeperiods/index")
            }
        }
        .lang("en-US")
    }
}
