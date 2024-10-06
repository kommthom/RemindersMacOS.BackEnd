//
//  RepetitionAddTemplate.swift
//  
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Vapor
import SwiftHtml

struct RepetitionAddTemplate: TemplateRepresentable {
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Add A New Repetition")
            }
            Body {
                H1("Add A New Repetition")
                Form {
                    Input().type(.hidden).name("repetitionId").value("")
                    Table {
                        Tr {
                            Td { Label("Repetition Type:").for("repetitiontype") }
                            Td {
                                Input().type(.text).list("repetitionypes").name("repetitiontype").value("none")
                                Datalist {
                                    Option("none")
                                    Option("Every_hour")
                                    Option("Every_hour_from_done")
                                    Option("Every_hour_of_day")
                                    Option("Every_hour_of_day_from_done")
                                    Option("Every_day")
                                    Option("Every_day_from_done")
                                    Option("Every_day_of_week")
                                    Option("Every_day_of_week_from_done")
                                    Option("Every_day_of_month")
                                    Option("Every_day_of_month_from_done")
                                    Option("Every_day_of_year")
                                    Option("Every_day_of_year_from_done")
                                    Option("Every_week")
                                    Option( "Every_week_from_done")
                                    Option("Every_weekday")
                                    Option("Every_weekday_from_done")
                                    Option("Every_week_of_month")
                                    Option("Every_week_of_month_from_done")
                                    Option("Every_week_of_year")
                                    Option("Every_week_of_year_from_done")
                                    Option("Every_month")
                                    Option("Every_month_from_done")
                                    Option("Every_month_of_year")
                                    Option("Every_month_of_year_from_done")
                                    Option("Every_year")
                                    Option("Every_year_from_done")
                                }
                                .id("repetitiontypes")
                                //.attribute("id", "valuetypes")
                            }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Repetition number:").for("repetitionnumber") }
                            Td { Input().type(.number).name("repetitionnumber").value("0") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Repetition Date:").for("repetitiondate") }
                            Td { Input().type(.text).name("repetitiondate").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Repetition End:").for("repetitionend") }
                            Td { Input().type(.text).name("repetitionend").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Repetition Text:").for("repetitiontext") }
                            Td { Input().type(.text).name("repetitiontext").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Whole Day?:").for("wholeday") }
                            Td { Input().type(.checkbox).name("wholeday").checked(false) }
                        }.style("background-color: #F0F0FF")
                        
                        Tr {
                            Td {
                                Button("Save")
                                    .type(.submit)
                                    .name("submit")
                                    .formaction("/repetitions/save")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("save-repetition-form")
                Br()
                A("List all repetitions").name("list-all-repetitions").href("/repetitions/index")
                Br()
                A("Home").name("home").href("/")
            }
        }
        .lang("en-US")
    }
}
