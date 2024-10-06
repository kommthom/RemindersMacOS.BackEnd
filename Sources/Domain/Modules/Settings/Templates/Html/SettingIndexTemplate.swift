//
//  SettingIndexTemplate.swift
//
//
//  Created by Thomas Benninghaus on 03.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct SettingIndexTemplate: TemplateRepresentable {
    var settingsContext: SettingsDTO

    init(_ settingsContext: SettingsDTO) {
        self.settingsContext = settingsContext
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("List All Settings")
            }
            Body {
                H1("List All Settings")
                Table {
                    Tr {
                        Td("Note: Update and Delete are accesible thru Show.")
                    }
                    Tr { Td() }
                    Tr {
                        Th("Scope").style("text-align:left")
                        Th("Name").style("text-align:left")
                        Th("Descrition").style("text-align:left")
                        Th("Type").style("text-align:left")
                        Th("Bool Value").style("text-align:left")
                        Th("Int Value").style("text-align:left")
                        Th("String Value").style("text-align:left")
                        Th("Id Value").style("text-align:left")
                        Th("JSON Value").style("text-align:left")
                    }
                    for settingContext in settingsContext.settings {
                        Tr {
                            Td(String(settingContext.scope.description))
                            Td(settingContext.name)
                            Td(settingContext.description)
                            Td(String(settingContext.valueType.description))
                            Td(String(settingContext.boolValue ?? false))
                            Td(String(settingContext.intValue ?? -1))
                            Td(settingContext.stringValue)
                            Td(settingContext.idValue?.uuidString)
                            Td(settingContext.jsonValue ?? "")

                            Td { A("Show").name("show-link")
                                    .href("/settings/show?settingId=\(settingContext.id!)")
                            }
                        }.style("background-color: #F0F0FF")
                    }
                    Tr { Td() }
                }
                Br()
                A("Home").name("home").href("/")
            }
        }.lang("en-US")
    }
}
