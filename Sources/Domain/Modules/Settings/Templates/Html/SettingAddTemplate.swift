//
//  SettingAddTemplate.swift
//
//
//  Created by Thomas Benninghaus on 03.02.24.
//

import Vapor
import SwiftHtml

struct SettingAddTemplate: TemplateRepresentable {
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Add A New Setting")
            }
            Body {
                H1("Add A New Setting")
                Form {
                    Input().type(.hidden).name("settingId").value("")
                    Table {
                        Tr {
                            Td { Label("Sort number:").for("sortorder") }
                            Td { Input().type(.number).name("sortorder").value("0") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("New Setting Scope:").for("scope") }
                            Td {
                                Input().type(.text).list("scopes").name("scope").value("")
                                Datalist {
                                    Option("none")
                                    Option("SidebarOptions")
                                    Option("Sidebar")
                                }
                                .id("scopes")
                                //.attribute("id", "scopes")
                            }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("New Setting Name:").for("name") }
                            Td { Input().type(.text).name("name").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("     Description:").for("description") }
                            Td { Input().type(.text).name("description").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("           Image:").for("image") }
                            Td { Input().type(.text).name("image").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("      Value Type:").for("valuetype") }
                            Td {
                                Input().type(.text).list("valuetypes").name("valuetype").value("Bool")
                                Datalist {
                                    Option("Bool")
                                    Option("Int")
                                    Option("String")
                                    Option("Id")
                                    Option("json")
                                }
                                .id("valuetypes")
                                //.attribute("id", "valuetypes")
                            }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("Bool Value").for("boolvalue") }
                            Td { Input().type(.checkbox).name("boolvalue").checked(false) }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("   Int Value:").for("intvalue") }
                            Td { Input().type(.number).name("intvalue").value("0") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label(" String Value:").for("stringvalue") }
                            Td { Input().type(.text).name("stringvalue").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("     Id Value:").for("idvalue") }
                            Td { Input().type(.text).name("idvalue").value("") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td { Label("  JSON Value:").for("jsonvalue") }
                            Td { Input().type(.number).name("jsonvalue").value("0") }
                        }.style("background-color: #F0F0FF")
                        Tr {
                            Td {
                                Button("Save")
                                    .type(.submit)
                                    .name("submit")
                                    .formaction("/settings/save")
                                    .formmethod(.post)
                            }
                        }
                    }
                }.name("save-setting-form")
                Br()
                A("List all settings").name("list-all-settings").href("/settings/index")
                Br()
                A("Home").name("home").href("/")
            }
        }
        .lang("en-US")
    }
}
