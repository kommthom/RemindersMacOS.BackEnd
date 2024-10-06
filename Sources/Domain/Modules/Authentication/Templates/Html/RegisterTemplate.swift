//
//  RegisterTemplate.swift
//  
//
//  Created by Thomas Benninghaus on 27.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct RegisterTemplate: TemplateRepresentable {
    @TagBuilder
    func render(_ req: Request) throws -> Tag {
        let localization =  req.userLocalization
        let authenticatedUserLanguage = req.auth.get(AuthenticatedUser.self)?.locale.rawValue ?? "de-DE"
        Html {
            Head {
                Title(localization.localize("register.head", interpolations: nil, req: req).htmlEscape())
            }
            Body {
                H1(localization.localize("register.head", interpolations: nil, req: req).htmlEscape())
                Form {
                    Input().type(.hidden).name("userId").value("")
                    Table {
                        Tr {
                            Td { Label(localization.localize("register.userid", interpolations: nil, req: req).htmlEscape()).for("name") }
                            Td { Tag("").id("name") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(localization.localize("register.username", interpolations: nil, req: req).htmlEscape()).for("fullName") }
                            Td { Input().type(.text).name("fullName").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(localization.localize("register.email", interpolations: nil, req: req).htmlEscape()).for("email") }
                            Td { Input().type(.text).name("email").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(localization.localize("register.image", interpolations: nil, req: req).htmlEscape()).for("imageURL") }
                            Td { Input().type(.text).name("imageURL").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(localization.localize("register.password", interpolations: nil, req: req).htmlEscape()).for("password") }
                            Td { Input().type(.password).name("password").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(localization.localize("register.confirm", interpolations: nil, req: req).htmlEscape()).for("confirmPassword") }
                            Td { Input().type(.password).name("confirmPassword").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(localization.localize("register.language", interpolations: nil, req: req).htmlEscape()).for("language") }
                            Td {
                                 Input().type(.text).list("languages").name("language").value("en")
                                 Datalist {
                                     for lang in LanguageIdentifier.allCases {
                                         Option(lang.description).value(lang.code)
                                     }
                                 }
                                 .id("languages")
                             }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button(localization.localize("register.save", interpolations: nil, req: req).htmlEscape())
                                    .type(.submit)
                                    .name("submit")
                                    .formaction("/auth/save")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("save-auth-form")
                Br()
                A(localization.localize("welcome.home", interpolations: nil, req: req).htmlEscape()).name("home").href("/")
            }
        }
        .lang(authenticatedUserLanguage)
    }
}

