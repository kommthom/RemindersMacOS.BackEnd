//
//  HistoryIndexTemplate.swift
//  
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct HistoryIndexTemplate: TemplateRepresentable {
    var context: HistoriesDTO

    init(_ context: HistoriesDTO) {
        self.context = context
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("List All status")
            }
            Body {
                H1("List All Status")
                Table {
                    Tr {
                        Td("Note: Update and Delete are accesible thru Show.")
                    }
                    Tr { Td() }
                    Tr {
                        Th("Timestamp").style("text-align:left")
                        Th("History Type").style("text-align:left")
                    }
                    for settingContext in context.histories {
                        Tr {
                            Td(settingContext.timestamp?.formatted())
                            Td(settingContext.historyType.description)

                            Td { A("Show").name("show-link")
                                    .href("/settings/show?settingId=\(settingContext.id!)")
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
