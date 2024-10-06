//
//  TemplateRenderer.swift
//
//
//  Created by Thomas Benninghaus on 29.01.24.
//

import Vapor
import SwiftHtml

public struct TemplateRenderer {
    var req: Request

    init(_ req: Request) {
        self.req = req
    }

    /// Convert SwiftHtml HTML output to a Response object.
    public func renderHtml(_ template: TemplateRepresentable, minify: Bool = false, indent: Int = 4) -> Response {
        let doc = Document(.html) { try! template.render(req) }
        let body = DocumentRenderer(minify: minify, indent: indent).render(doc)
        return Response(status: .ok, headers: ["content-type": "text/html"], body: .init(string: body))
    }
}
