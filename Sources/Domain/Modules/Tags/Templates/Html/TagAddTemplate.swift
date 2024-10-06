//
//  TagAddTemplate.swift
//
//
//  Created by Thomas Benninghaus on 08.02.24.
//

import Vapor
import SwiftHtml

struct TagAddTemplate: TemplateRepresentable {
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Add A New Tag")
            }
            Body {
                H1("Add A New Tag")
                Form {
                    Input().type(.hidden).name("tagId").value("")
                    Table {
                        Tr {
                            Td { Label("Description:").for("description") }
                            Td { Input().type(.text).name("description").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button("Save")
                                    .type(.submit)
                                    .name("submit")
                                    .formaction("/tags/save")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("save-tag-form")
                Br()
                A("List all tags").name("list-all-tags").href("/tags/index")
                Br()
                A("Home").name("home").href("/")
            }
        }
        .lang("en-US")
    }
}
