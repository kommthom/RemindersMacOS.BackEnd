//
//  AttachmentAddTemplate.swift
//
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Vapor
import SwiftHtml

struct AttachmentAddTemplate: TemplateRepresentable {
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Add A New Attachment")
            }
            Body {
                H1("Add A New Attachment")
                Form {
                    Input().type(.hidden).name("attachmentId").value("")
                    Table {
                        Tr {
                            Td { Label("Comment:").for("comment") }
                            Td { Input().type(.text).name("comment").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Attachment Type:").for("attachmenttype") }
                            Td {
                                Input().type(.text).list("attachmenttypes").name("attachmenttype").value("none")
                                Datalist {
                                    Option("AnyFileType")
                                    Option("Audio")
                                    Option("Emoji")
                                    Option("Integration")
                                    Option("none")
                                }
                                .id("attachmenttypes")
                                //.attribute("id", "valuetypes")
                            }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("New Attachment FileName:").for("filename") }
                            Td { Input().type(.text).name("filename").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button("Save")
                                    .type(.submit)
                                    .name("submit")
                                    .formaction("/attachments/save")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("save-attachment-form")
                Br()
                A("List all attachments").name("list-all-attachments").href("/attachments/index")
                Br()
                A("Home").name("home").href("/")
            }
        }
        .lang("en-US")
    }
}
