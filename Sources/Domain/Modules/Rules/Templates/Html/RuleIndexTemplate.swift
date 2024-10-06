//
//  RuleIndexTemplate.swift
//  
//
//  Created by Thomas Benninghaus on 16.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct RuleIndexTemplate: TemplateRepresentable {
    var context: RulesDTO

    init(_ rulesContext: RulesDTO) {
        self.context = rulesContext
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("List All Rules")
            }
            Body {
                H1("List All Rules")
                Table {
                    Tr {
                        Td("Note: Update and Delete are accesible thru Show.")
                    }
                    Tr { Td() }
                    Tr {
                        Th("Description").style("text-align:left")
                        Th("Rule Type").style("text-align:left")
                        Th("Action Type").style("text-align:left")
                        Th("Arguments").style("text-align:left")
                    }
                    for ruleContext in context.rules {
                        Tr {
                            Td(String(ruleContext.description))
                            Td(String(ruleContext.ruleType.description))
                            Td(String(ruleContext.actionType.description))
                            Td(String(ruleContext.args?.joined() ?? ""))

                            Td { A("Show").name("show-link")
                                    .href("/rules/show?ruleId=\(ruleContext.id!)")
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
