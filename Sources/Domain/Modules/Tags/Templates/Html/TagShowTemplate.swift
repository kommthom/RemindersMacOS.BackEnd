//
//  TagShowTemplate.swift
//  
//
//  Created by Thomas Benninghaus on 08.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct TagShowTemplate: TemplateRepresentable {
    var context: TagDTO

    init(_ context: TagDTO) {
        self.context = context
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Show A Tag")
            }
            Body {
                H1("Show A Tag")
                Form {
                    Input().type(.hidden).name("tagId").value(context.id?.uuidString)
                    Table {
                        Tr {
                            Td { Label("Description:").for("description") }
                            Td { Input().type(.text).name("description").value(context.description) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button("Update")
                                    .type(.submit)
                                    .name("update")
                                    .formaction("/tags/update")
                                    .formmethod(.post)
                                Button("Delete")
                                    .type(.submit)
                                    .name("delete")
                                    .formaction("/tags/delete")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("show-tag-form")
                Br()
                A("Home").name("home").href("/")
                Br()
                A("List all tags").name("show-tags").href("/tags/index")
            }
        }
        .lang("en-US")
    }
}
