//
//  AttachmentIndexTemplate.swift
//
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct AttachmentIndexTemplate: TemplateRepresentable {
    var context: AttachmentsDTO

    init(_ context: AttachmentsDTO) {
        self.context = context
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("List All Attachments")
            }
            Body {
                H1("List All Attachments")
                Table {
                    Tr {
                        Td("Note: Update and Delete are accesible thru Show.")
                    }
                    Tr { Td() }
                    Tr {
                        Th("Comment").style("text-align:left")
                    }
                    for attachmentContext in context.attachments {
                        Tr {
                            Td(String(attachmentContext.comment))

                            Td { A("Show").name("show-link")
                                    .href("/attachments/show?attachmentId=\(attachmentContext.id!)")
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
