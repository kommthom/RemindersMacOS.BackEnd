//
//  LocaleRedirectMiddleware.swift
//
//
//  Created by Thomas Benninghaus on 04.01.24.
//

import Vapor

public final class LocaleRedirectMiddleware: Middleware {
    public init() {}
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        // Check if a language is passed in url
        guard let locale = request.parameters.get("locale")
        else {
            // Redirect corresponding to specified locale
            // For example, `/home/` will redirect to `/<request.locale>/home/`
            return request.eventLoop.makeSucceededFuture(
                request.redirect(to: "/\(request.locale)\(request.url.path)")
            )
        }
        
        // Get Lingo instance
        guard let localization = try? request.application.localization.provide(),
              let locales = try? localization.dataSource.availableLocales()
        else {
            return request.eventLoop.makeFailedFuture(Abort(
                .internalServerError, reason: "Unable to get Localization instance"
            ))
        }
        
        // Check that the locale is available, else it's a 404
        guard locales.contains(locale)
        else {
            return request.eventLoop.makeFailedFuture(Abort(.notFound))
        }
        
        // Set request locale from url
        // For example, `/fr/home/` will display homepage in French
        request.session.data["locale"] = locale
        return next.respond(to: request)
    }
}

