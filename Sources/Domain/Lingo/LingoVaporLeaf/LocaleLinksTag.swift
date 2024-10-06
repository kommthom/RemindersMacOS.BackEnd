//
//  LocaleLinksTag.swift
//
//
//  Created by Thomas Benninghaus on 13.01.24.
//

import Vapor
import Leaf
import Resources

public final class LocaleLinksTag: UnsafeUnescapedLeafTag {
    public init() {}
    public func render(_ ctx: LeafContext) throws -> LeafData {
        guard let provider = ctx.application?.localization else {
            throw Abort(.internalServerError, reason: "Unable to get Localization provider")
        }
        let lingo = try provider.provide()
        let locale = ctx.request?.locale ?? ResourcePaths.defaultLanguage
        
        guard ctx.parameters.count == 2,
              let prefix = ctx.parameters[0].string,
              let suffix = ctx.parameters[1].string
        else {
            throw Abort(.internalServerError, reason: "Wrong parameters count")
        }
        
        let canonical = "<link rel=\"canonical\" href=\"\(prefix)\(locale)\(suffix)\" />\n"
        
        let alternates = try lingo.dataSource.availableLocales().map { alternate in
            "<link rel=\"alternate\" hreflang=\"\(alternate)\" href=\"\(prefix)\(alternate)\(suffix)\" />\n"
        }
        
        return LeafData.string(canonical + alternates.joined())
    }
}
