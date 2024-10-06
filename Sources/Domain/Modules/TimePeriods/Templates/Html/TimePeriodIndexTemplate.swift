//
//  TimePeriodIndexTemplate.swift
//  
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct TimePeriodIndexTemplate: TemplateRepresentable {
    var context: TimePeriodsDTO

    init(_ tagsContext: TimePeriodsDTO) {
        self.context = tagsContext
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("List All Timeperiods")
            }
            Body {
                H1("List All Timeperiods")
                Table {
                    Tr {
                        Td("Note: Update and Delete are accesible thru Show.")
                    }
                    Tr { Td() }
                    Tr {
                        Th("Type of Time").style("text-align:left")
                        Th("From").style("text-align:left")
                        Th("To").style("text-align:left")
                        Th("Day").style("text-align:left")
                    }
                    for timeperiodContext in context.timePeriods {
                        Tr {
                            Td(timeperiodContext.typeOfTime.rawValue)
                            Td(timeperiodContext.from)
                            Td(timeperiodContext.to)
                            Td(timeperiodContext.day?.formatted())

                            Td { A("Show").name("show-link")
                                    .href("/timeperiods/show?timeperiodId=\(timeperiodContext.id!)")
                            }
                        }.style("background-color: #F0F0FF")
                    }
                    Tr { Td() }
                }
                Br()
                A("Home").name("home").href("/")
            }
        }.lang("en-US")
    }
}
