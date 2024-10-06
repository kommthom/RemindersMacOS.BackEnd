//
//  UserAddTemplate.swift
//
//
//  Created by Thomas Benninghaus on 06.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct UserAddTemplate: TemplateRepresentable {
    @TagBuilder
    func render(_ req: Request) throws -> Tag {
        let localization = req.userLocalization
        let authenticatedUserLanguage = req.auth.get(AuthenticatedUser.self)?.locale.description ?? "de-DE"
        Html {
            Head {
                Title(localization.localize("adduser.head", interpolations: nil, req: req).htmlEscape())
            }
            Body {
                H1(localization.localize("adduser.head", interpolations: nil, req: req).htmlEscape())
                Form {
                    Input().type(.hidden).name("userId").value("")
                    Table {
                        Tr {
                            Td { Label(localization.localize("adduser.userid", interpolations: nil, req: req).htmlEscape()).for("name") }
                            Td { Tag("").id("name") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(localization.localize("adduser.username", interpolations: nil, req: req).htmlEscape()).for("name") }
                            Td { Input().type(.text).name("name").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(localization.localize("adduser.email", interpolations: nil, req: req).htmlEscape()).for("email") }
                            Td { Input().type(.text).name("email").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(localization.localize("adduser.image", interpolations: nil, req: req).htmlEscape()).for("image") }
                            Td { Input().type(.text).name("image").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(localization.localize("adduser.password", interpolations: nil, req: req).htmlEscape()).for("password") }
                            Td { Input().type(.password).name("password").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(localization.localize("adduser.isadmin", interpolations: nil, req: req).htmlEscape()).for("isadmin") }
                            Td { Input().type(.checkbox).name("isadmin").checked(false) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(localization.localize("adduser.language", interpolations: nil, req: req).htmlEscape()).for("language") }
                            Td {
                                 Input().type(.text).list("languages").name("language").value("en")
                                 Datalist {
                                     for lang in LanguageIdentifier.allCases {
                                         Option(lang.name).value(lang.code)
                                     }
                                 }
                                 .id("languages")
                             }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button(localization.localize("adduser.save", interpolations: nil, req: req).htmlEscape())
                                    .type(.submit)
                                    .name("submit")
                                    .formaction("/users/save")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("save-user-form")
                Br()
                A(localization.localize("adduser.list", interpolations: nil, req: req).htmlEscape()).name("list-all-users").href("/users/index")
                Br()
                A(localization.localize("welcome.home", interpolations: nil, req: req).htmlEscape()).name("home").href("/")
            }
        }
        .lang(authenticatedUserLanguage)
    }
}
