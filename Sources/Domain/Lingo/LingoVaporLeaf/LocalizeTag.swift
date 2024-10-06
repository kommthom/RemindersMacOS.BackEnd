//
//  LocalizeTag.swift
//
//
//  Created by Thomas Benninghaus on 13.01.24.
//

import Vapor
import Leaf
import Lingo
import Resources

public final class LocalizeTag: UnsafeUnescapedLeafTag {
    public init() {}
    public func render(_ ctx: LeafContext) throws -> LeafData {
        let parametersCount = ctx.parameters.count
        if parametersCount == 0 {
            throw Abort(.internalServerError, reason: "No parameters provided for localize tag!")
        }
        guard let key: String = ctx.parameters.first?.string else {
            throw Abort(.internalServerError, reason: "First parameter for localize tag is no string (\(ctx.parameters.first?.string ?? String(describing: ctx.parameters.first?.uniformType?.rawValue)))")
        }
        var lingo: LocalizationProtocol? = try ctx.application?.localization.provide()
        if let _ = lingo  {
        } else {
            //throw Abort(.internalServerError, reason: "Context has no application")
            //for i in 1 ... ctx.parameters.count - 1 {
            //    key = "\(key), \(ctx.parameters[i].string ?? String(describing: ctx.parameters[i].uniformType?.rawValue))"
            //}
            //return LeafData.string("Application error: \(key)")
            lingo = try Lingo(rootPath: ResourcePaths.localizationsPath.path, defaultLocale: ResourcePaths.defaultLanguage)
            guard let _ = lingo else {
                throw Abort(.internalServerError, reason: "Lingo could not be instantiated")
            }
        }
        var locale = ctx.request?.locale ?? ResourcePaths.defaultLanguage
        
        switch parametersCount {
        case 1:
            return LeafData.string(lingo!.localize(key, locale: locale, interpolations: nil).htmlEscaped())
        case 2:
            guard let body = ctx.parameters[1].string,
                  let bodyData = body.data(using: .utf8),
                  let interpolations = try? JSONSerialization.jsonObject(with: bodyData, options: []) as? [String: AnyObject] else {
                throw Abort(.internalServerError, reason: "Unable to convert interpolations to string (\(ctx.parameters[1].string ?? "nil"))")
            }
            if key.lowercased().contains("url") {
                return LeafData.string(lingo!.localize(key, locale: locale, interpolations: interpolations))
            } else {
                return LeafData.string(lingo!.localize(key, locale: locale, interpolations: interpolations).htmlEscaped())
            }
        default:
            if ctx.parameters.count % 2 == 0 {
                throw Abort(.internalServerError, reason: "invalid parameters provided for localize tag")
            } else {
                var interpolations: [String: String] = [:]
                try stride(from: 1, to: ctx.parameters.count, by: 2).forEach { i in
                    guard let interpolationKey = ctx.parameters[i].string,
                          let interpolationValue = ctx.parameters[i + 1].string else {
                        throw Abort(.internalServerError, reason: "Unable to convert interpolations to string (\(ctx.parameters[i].string ?? "nil")/\(ctx.parameters[i + 1].string ?? "nil")")
                    }
                    if interpolationKey == "locale" {
                        locale = interpolationValue //override request locale
                    } else {
                        interpolations[interpolationKey] = interpolationValue
                    }
                }
                if key.lowercased().contains("url") {
                    return LeafData.string(lingo!.localize(key, locale: locale, interpolations: interpolations))
                } else {
                    return LeafData.string(lingo!.localize(key, locale: locale, interpolations: interpolations).htmlEscape(useNamedReferences: true))
                }
            }
        }
    }
}
