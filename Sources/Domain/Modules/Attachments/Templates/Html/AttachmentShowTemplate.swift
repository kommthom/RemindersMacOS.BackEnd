//
//  AttachmentShowTemplate.swift
//
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct AttachmentShowTemplate: TemplateRepresentable {
    var context: AttachmentDTO

    init(_ context: AttachmentDTO) {
        self.context = context
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Show A Attachment")
            }
            Body {
                H1("Show A Attachment")
                Form {
                    Input().type(.hidden).name("attachmentId").value(context.id?.uuidString)
                    Table {
                        Tr {
                            Td { Label("Attachment ID:").for("name") }
                            Td { Tag(context.id?.uuidString).id("name") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Comment:").for("comment") }
                            Td { Input().type(.text).name("comment").value(context.comment) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button("Update")
                                    .type(.submit)
                                    .name("update")
                                    .formaction("/attachments/update")
                                    .formmethod(.post)
                                Button("Delete")
                                    .type(.submit)
                                    .name("delete")
                                    .formaction("/attachments/delete")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("show-attachment-form")
                Br()
                A("Home").name("home").href("/")
                Br()
                A("List all attachments").name("show-attachments").href("/attachments/index")
            }
        }
        .lang("en-US")
    }
}
