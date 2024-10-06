//
//  UserIndexTemplate.swift
//
//
//  Created by Thomas Benninghaus on 06.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct UserIndexTemplate: TemplateRepresentable {
    var usersContext: UsersDTO

    init(_ usersContext: UsersDTO) {
        self.usersContext = usersContext
    }

    @TagBuilder
    func render(_ req: Request) throws -> Tag {
        let localization = req.userLocalization
        let authenticatedUserLanguage = req.auth.get(AuthenticatedUser.self)?.locale.rawValue ?? "de-DE"
        Html {
            Head {
                Title(localization.localize("listusers.head", interpolations: nil, req: req).htmlEscape())
            }
            Body {
                H1(localization.localize("listusers.head", interpolations: nil, req: req).htmlEscape())
                Table {
                    Tr {
                        Td(localization.localize("list.note", interpolations: nil, req: req).htmlEscape())
                    }
                    Tr { Td() }
                    Tr {
                        Th(localization.localize("list.id", interpolations: nil, req: req).htmlEscape()).style("text-align:left")
                        Th(localization.localize("listusers.fullname", interpolations: nil, req: req).htmlEscape()).style("text-align:left")
                        Th(localization.localize("listusers.email", interpolations: nil, req: req).htmlEscape()).style("text-align:left")
                        Th(localization.localize("listusers.image", interpolations: nil, req: req).htmlEscape()).style("text-align:left")
                        Th(localization.localize("listusers.isadmin", interpolations: nil, req: req).htmlEscape()).style("text-align:left")
                        Th(localization.localize("listusers.language", interpolations: nil, req: req).htmlEscape()).style("text-align:left")
                    }
                    for userContext in usersContext.users {
                        Tr {
                            Td(String(userContext.id?.uuidString ?? ""))
                            Td(userContext.fullName)
                            Td(userContext.email)
                            Td(userContext.imageURL)
                            Td(String(userContext.isAdmin))
                            Td(userContext.locale.language.code)

                            Td { A(localization.localize("list.show", interpolations: nil, req: req).htmlEscape()).name("show-link")
                                    .href("/users/show?id=\(userContext.id?.uuidString ?? "")")
                            }
                        }.style("background-color: #F0F0FF")
                    }
                    Tr { Td() }
                }
                Br()
                A(localization.localize("welcome.home", interpolations: nil, req: req).htmlEscape()).name("home").href("/")
            }
        }.lang(authenticatedUserLanguage)
    }
}
