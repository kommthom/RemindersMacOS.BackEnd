//
//  SettingShowTemplate.swift
//
//
//  Created by Thomas Benninghaus on 03.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct SettingShowTemplate: TemplateRepresentable {
    var settingContext: SettingDTO

    init(_ context: SettingDTO) {
        self.settingContext = context
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Show A Setting")
            }
            Body {
                H1("Show A Setting")
                Form {
                    Input().type(.hidden).name("settingId").value(settingContext.id?.uuidString)
                    Input().type(.hidden).name("scope").value(settingContext.scope.rawValue)
                    Input().type(.hidden).name("settingName").value(settingContext.name)
                    Table {
                        Tr {
                            Td { Label("Setting ID:").for("name") }
                            Td { Tag(settingContext.id?.uuidString).id("name") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Sort number:").for("sortorder") }
                            Td { Input().type(.number).name("sortorder").value(String(settingContext.sortOrder)) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Setting Scope:").for("scope") }
                            Td { Tag(settingContext.scope.rawValue).id("scope") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Setting Name:").for("name") }
                            Td { Tag(settingContext.name).id("name") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Description:").for("description") }
                            Td { Input().type(.text).name("description").value(settingContext.description) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Image:").for("image") }
                            Td { Input().type(.text).name("image").value(settingContext.image) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Value Type:").for("valuetype") }
                            Td {
                                Input().type(.text).list("valuetypes").name("valuetype").value(settingContext.valueType.rawValue)
                                Datalist {
                                    Option("Bool")
                                    Option("Int")
                                    Option("String")
                                    Option("Id")
                                    Option("json")
                                }
                                .id("valuetypes")
                            }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Bool Value:").for("boolvalue") }
                            Td { Input().type(.checkbox).name("boolvalue").checked(settingContext.boolValue ?? false) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Int Value:").for("intvalue") }
                            Td { Input().type(.number).name("intvalue").value(String(settingContext.intValue ?? 0)) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("String Value:").for("stringvalue") }
                            Td { Input().type(.text).name("stringvalue").value(settingContext.stringValue) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Id Value:").for("idvalue") }
                            Td { Input().type(.text).name("idvalue").value(settingContext.idValue?.uuidString) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("JSON Value:").for("jsonvalue") }
                            Td { Input().type(.number).name("jsonvalue").value(settingContext.jsonValue) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button("Update")
                                    .type(.submit)
                                    .name("update")
                                    .formaction("/settings/update")
                                    .formmethod(.post)
                                Button("Delete")
                                    .type(.submit)
                                    .name("delete")
                                    .formaction("/settings/delete")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("show-setting-form")
                Br()
                A("Home").name("home").href("/")
                Br()
                A("List all settings").name("show-settings").href("/settings/index")
            }
        }
        .lang("en-US")
    }
}
