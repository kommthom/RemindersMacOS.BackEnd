//
//  TagIndexTemplate.swift
//  
//
//  Created by Thomas Benninghaus on 08.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct TagIndexTemplate: TemplateRepresentable {
    var context: TagsDTO

    init(_ tagsContext: TagsDTO) {
        self.context = tagsContext
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("List All Tags")
            }
            Body {
                H1("List All Tags")
                Table {
                    Tr {
                        Td("Note: Update and Delete are accesible thru Show.")
                    }
                    Tr { Td() }
                    Tr {
                        Th("Description").style("text-align:left")
                    }
                    for tagContext in context.tags {
                        Tr {
                            Td(tagContext.description)

                            Td { A("Show").name("show-link")
                                    .href("/tags/show?tagId=\(tagContext.id!)")
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
