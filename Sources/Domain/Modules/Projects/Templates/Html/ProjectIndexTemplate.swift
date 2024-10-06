//
//  ProjectIndexTemplate.swift
//  
//
//  Created by Thomas Benninghaus on 11.02.24.
//

import Vapor
import SwiftHtml
import DTO

struct ProjectIndexTemplate: TemplateRepresentable {
    var context: ProjectsDTO

    init(_ projectsContext: ProjectsDTO) {
        self.context = projectsContext
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("List All Projects")
            }
            Body {
                H1("List All Projects")
                Table {
                    Tr {
                        Td("Note: Update and Delete are accesible thru Show.")
                    }
                    Tr { Td() }
                    Tr {
                        Th("Left Key").style("text-align:left")
                        Th("Right Key").style("text-align:left")
                        Th("Name").style("text-align:left")
                        Th("Completed").style("text-align:left")
                        Th("Level").style("text-align:left")
                        Th("Path").style("text-align:left")
                    }
                    for projectContext in context.projects {
                        Tr {
                            Td(String(projectContext.leftKey))
                            Td(String(projectContext.rightKey))
                            Td(projectContext.name)
                            Td(String(projectContext.isCompleted))
                            Td(String(projectContext.level))
                            Td(projectContext.path)

                            Td { A("Show").name("show-link")
                                    .href("/projects/show?sprojectId=\(projectContext.id!)")
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
