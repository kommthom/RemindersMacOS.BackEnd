//
//  RepetitionIndexTemplate.swift
//  
//
//  Created by Thomas Benninghaus on 17.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct RepetitionIndexTemplate: TemplateRepresentable {
    var context: RepetitionsDTO

    init(_ context: RepetitionsDTO) {
        self.context = context
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("List All Repetitions")
            }
            Body {
                H1("List All Repetitions")
                Table {
                    Tr {
                        Td("Note: Update and Delete are accesible thru Show.")
                    }
                    Tr { Td() }
                    Tr {
                        Th("Repetition Number").style("text-align:left")
                        Th("Repetition Date").style("text-align:left")
                        Th("Repetition End").style("text-align:left")
                        Th("Text").style("text-align:left")
                    }
                    for repetitionContext in context.repetitions {
                        Tr {
                            Td(String(repetitionContext.repetitionNumber))
                            Td(repetitionContext.repetitionJSON)
                            Td(repetitionContext.repetitionEnd?.formatted())
                            Td(repetitionContext.repetitionText)

                            Td { A("Show").name("show-link")
                                    .href("/repetitions/show?repetitionId=\(repetitionContext.id!)")
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
