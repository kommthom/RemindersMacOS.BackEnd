//
//  WelcomeTemplate.swift
//  
//
//  Created by Thomas Benninghaus on 20.01.24.
//

import Vapor
import Fluent
import SwiftHtml

struct WelcomeTemplate: TemplateRepresentable {
    @TagBuilder
    func render(_ req: Request) throws -> Tag {
        let localization = req.userLocalization
        let authenticatedUserName = req.auth.get(AuthenticatedUser.self)?.name ?? ""
        let authenticatedUserLanguage = req.auth.get(AuthenticatedUser.self)?.locale.rawValue ?? "de-DE"
        Html {
            Head {
                Title(localization.localize("welcome.home", interpolations: nil, req: req).htmlEscape())
            }
            Body {
                MenuTemplate().render(req)
                H1(localization.localize("welcome.header.web", interpolations: nil, req: req).htmlEscape())
                H3(localization.localize("welcome.header3.web", interpolations: nil, req: req).htmlEscape())
                if authenticatedUserName.isEmpty {
                    P(localization.localize("welcome.choices", interpolations: nil, req: req).htmlEscape())
                    Ul {
                        Li { A(localization.localize("welcome.register", interpolations: nil, req: req).htmlEscape()).name("register").href("/auth/register") }
                        Li { A(localization.localize("welcome.login", interpolations: nil, req: req).htmlEscape()).name("sign-in").href("/auth/sign-in") }
                    }
                } else {
                    P(localization.localize("welcome.username", locale: req.locale, interpolations: ["authenticatedUserName": authenticatedUserName]).htmlEscape())
                    P(localization.localize("welcome.choices", interpolations: nil, req: req).htmlEscape())
                    Ul {
                        Li { A(localization.localize("welcome.listprojects", interpolations: nil, req: req).htmlEscape()).name("show").href("/projects/index") }
                        Li { A(localization.localize("welcome.addproject", interpolations: nil, req: req).htmlEscape()).name("add").href("/projects/add") }
                    }
                    if req.isAdministrator() {
                        P(localization.localize("welcome.adminchoices", interpolations: nil, req: req).htmlEscape())
                        Ul {
                            Li { A(localization.localize("welcome.listusers", interpolations: nil, req: req).htmlEscape()).name("list-all-users").href("/users/index") }
                            Li { A(localization.localize("welcome.register", interpolations: nil, req: req).htmlEscape()).name("register").href("/auth/register") }
                            Li { A(localization.localize("welcome.logout", interpolations: nil, req: req).htmlEscape()).name("sign-out").href("/auth/sign-out") }
                        }
                    }
                }
            }
        }
        .lang(authenticatedUserLanguage)
    }
}
