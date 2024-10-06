//
//  SignInTemplate.swift
//
//
//  Created by Thomas Benninghaus on 29.01.24.
//

import Vapor
import SwiftHtml

struct SignInTemplate: TemplateRepresentable {
    let context: SignInContext

    init(_ context: SignInContext) {
        self.context = context
    }

    @TagBuilder
    func render(_ req: Request) throws -> Tag {
        let localization = req.userLocalization
        let authenticatedUserLanguage = req.auth.get(AuthenticatedUser.self)?.locale.rawValue ?? "de-DE"
        Html {
            Head {
                Title(localization.localize("signin.head", interpolations: nil, req: req).htmlEscape())
            }
            Body {
                H1(localization.localize("signin.head", interpolations: nil, req: req).htmlEscape())
                if let _ = context.error {
                    H3(context.error)
                }
                Form {
                    Table {
                        Tr {
                            Td {
                                Label(localization.localize("signin.email", interpolations: nil, req: req).htmlEscape()).for("email")
                            }
                            Td {
                                Input().type(.text).name("email").value(context.name)
                            }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Label(localization.localize("signin.password", interpolations: nil, req: req).htmlEscape()).for("password")
                            }
                            Td {
                                Input().type(.password).name("password").value("")
                            }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button(localization.localize("signin.login", interpolations: nil, req: req).htmlEscape())
                                    .type(.submit)
                                    .name("log-in")
                                    .formaction("/auth/login")
                                    .formmethod(.post)
                                    .formenctype(.urlencoded)
                            }
                        }
                    }
                }.name("sign-in-form")
                Br()
                A(localization.localize("welcome.home", interpolations: nil, req: req).htmlEscape()).name("home").href("/")
            }
        }
        .lang(authenticatedUserLanguage)
    }
}
