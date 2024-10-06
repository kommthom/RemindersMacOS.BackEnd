//
//  MenuTemplate.swift
//
//
//  Created by Thomas Benninghaus on 20.01.24.
//

import Vapor
import SwiftHtml

struct MenuTemplate: TemplateRepresentable {
    private func localize(_ key: String, _ req: Request) -> String {
        do {
            let localization = req.userLocalization
            return localization.localize(key, locale: req.locale, interpolations: nil).htmlEscape()
        } catch let error {
            return error.localizedDescription
        }
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Link(rel: .stylesheet).href("/Styles/Menu.css")
        Div {
            A(localize("menu.welcome", req))
                .href("/")
            if req.auth.has(AuthenticatedUser.self) {
                Div {
                    Button(localize("welcome.home", req)).class("dropbtn")
                    Div {
                        A(localize("menu.restore", req)).name("create").href("/projects/create")
                    }.class("dropdown-content")
                }.class("dropdown")
                Div {
                    Button(localize("menu.projects", req)).class("dropbtn")
                    Div {
                        A(localize("menu.listprojects", req)).href("/projects/index")
                        A(localize("menu.addproject", req)).name("add").href("/projects/add")
                    }.class("dropdown-content")
                }.class("dropdown")
                if req.isAdministrator() {
                    Div {
                        Button(localize("menu.administrator", req)).class("dropbtn")
                        Div {
                            A(localize("menu.listusers", req)).name("list-all-users").href("/users/index")
                        }.class("dropdown-content")
                    }.class("dropdown")
                }
                A(localize("welcome.logout", req)).name("sign-out").href("/auth/sign-out")
            } else {
                A(localize("welcome.register", req)).name("register").href("/auth/register")
                A(localize("welcome.login", req)).name("sign-in").href("/auth/sign-in")
            }
        }.class("navbar")
    }
}

