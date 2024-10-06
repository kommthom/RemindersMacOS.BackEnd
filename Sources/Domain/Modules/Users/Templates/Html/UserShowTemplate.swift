//
//  UserShowTemplate.swift
//
//
//  Created by Thomas Benninghaus on 06.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct UserShowTemplate: TemplateRepresentable {
    var userContext: UserDTO

    init(_ context: UserDTO) {
        self.userContext = context
    }

    @TagBuilder
    func render(_ req: Request) throws -> Tag {
        let authenticatedUserLanguage = req.userLocalization.getAuthenticatedUser(req).locale.rawValue
        Html {
            Head {
                Title(req.userLocalization.localize("user.head", interpolations: nil, req: req).htmlEscape())
            }
            Body {
                H1(req.userLocalization.localize("user.head", interpolations: nil, req: req).htmlEscape())
                Form {
                    Input().type(.hidden).name("userId").value(userContext.id?.uuidString)
                    Table {
                        Tr {
                            Td { Label(req.userLocalization.localize("user.userid", interpolations: nil, req: req).htmlEscape()).for("name") }
                            Td { Tag(userContext.id?.uuidString).id("name") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(req.userLocalization.localize("user.fullname", interpolations: nil, req: req).htmlEscape()).for("name") }
                            Td { Input().type(.text).name("name").value(userContext.fullName) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(req.userLocalization.localize("user.email", interpolations: nil, req: req).htmlEscape()).for("email") }
                            Td { Input().type(.text).name("email").value(userContext.email) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(req.userLocalization.localize("user.image", interpolations: nil, req: req).htmlEscape()).for("image") }
                            Td { Input().type(.text).name("image").value(userContext.imageURL) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(req.userLocalization.localize("user.isadmin", interpolations: nil, req: req).htmlEscape()).for("isadmin") }
                            Td { Input().type(.checkbox).name("isadmin").checked(userContext.isAdmin) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(req.userLocalization.localize("user.language", interpolations: nil, req: req).htmlEscape()).for("language") }
                            Td {
                                Input().type(.text).list("languages").name("language").value(userContext.locale.language.code)
                                Datalist {
                                    Option("de")
                                    Option("en")
                                }
                                .id("languages")
                            }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button(req.userLocalization.localize("user.update", interpolations: nil, req: req).htmlEscape())
                                    .type(.submit)
                                    .name("update")
                                    .formaction("/users/update")
                                    .formmethod(.post)
                                Button(req.userLocalization.localize("user.delete", interpolations: nil, req: req).htmlEscape())
                                    .type(.submit)
                                    .name("delete")
                                    .formaction("/users/delete")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("show-user-form")
                Br()
                A(req.userLocalization.localize("welcome.home", interpolations: nil, req: req).htmlEscape()).name("home").href("/")
                Br()
                A(req.userLocalization.localize("user.head", interpolations: nil, req: req).htmlEscape()).name("show-users").href("/users/index")
            }
        }
        .lang(authenticatedUserLanguage)
    }
}

