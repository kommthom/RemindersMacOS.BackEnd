//
//  LocaleTag.swift
//  
//
//  Created by Thomas Benninghaus on 13.01.24.
//

import Vapor
import Leaf
import Resources

public final class LocaleTag: LeafTag {
    public init() {}
    public func render(_ ctx: LeafContext) throws -> LeafData {
        return LeafData.string(ctx.request?.locale ?? ResourcePaths.defaultLanguage)
    }
}
