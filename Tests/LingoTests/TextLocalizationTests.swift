//
//  TextLocalizationTests.swift
//
//
//  Created by Thomas Benninghaus on 06.01.24.
//

import XCTest
import Lingo
import Resources
@testable import Domain

final class TextLocalizationTests: XCTestCase {
    
    let localizationsRootPath = NSTemporaryDirectory().appending("LingoTests")
    
    override func setUp() {
        super.setUp()
        try! DefaultFixtures.setup(atPath: self.localizationsRootPath) // swiftlint:disable:this force_try
    }
    
    func testTextLocalizationWithoutInterpolations() throws {
        let textBuilder = TextLocalization(inputString: DefaultFixtures.testText, localization: try Lingo(rootPath: localizationsRootPath, defaultLocale: ResourcePaths.defaultLanguage.code), textConverter: nil)
        XCTAssertEqual(textBuilder.localize(languageCode: "en", interpolations: nil), DefaultFixtures.expectedResults["testText/en"])
        XCTAssertEqual(textBuilder.localize(languageCode: "de", interpolations: nil), DefaultFixtures.expectedResults["testText/de"])
    }

    func testTextLocalizationWithInterpolations() throws {
        let textBuilder = TextLocalization(inputString: DefaultFixtures.testTextWithInterpolations, localization: try Lingo(rootPath: localizationsRootPath, defaultLocale: ResourcePaths.defaultLanguage.code), textConverter: nil)
        XCTAssertEqual(textBuilder.localize(languageCode: "en", interpolations: DefaultFixtures.interpolations), DefaultFixtures.expectedResults["testTextWithInterpolations/en"])
        XCTAssertEqual(textBuilder.localize(languageCode: "de", interpolations: DefaultFixtures.interpolations), DefaultFixtures.expectedResults["testTextWithInterpolations/de"])
    }
    
    func testHtmlLocalizationWithoutInterpolations() throws {
        let textBuilder = TextLocalization(inputString: DefaultFixtures.testHtml, localization: try Lingo(rootPath: localizationsRootPath, defaultLocale: ResourcePaths.defaultLanguage.code), textConverter: stringHtmlEscape)
        XCTAssertEqual(textBuilder.localize(languageCode: "en", interpolations: nil), DefaultFixtures.expectedResults["testHtml/en"])
        XCTAssertEqual(textBuilder.localize(languageCode: "de", interpolations: nil), DefaultFixtures.expectedResults["testHtml/de"])
    }

    func testHtmlLocalizationWithInterpolations() throws {
        let textBuilder = TextLocalization(inputString: DefaultFixtures.testHtmlWithInterpolations, localization: try Lingo(rootPath: localizationsRootPath, defaultLocale: ResourcePaths.defaultLanguage.code), textConverter: stringHtmlEscape)
        XCTAssertEqual(textBuilder.localize(languageCode: "en", interpolations: DefaultFixtures.interpolations), DefaultFixtures.expectedResults["testHtmlWithInterpolations/en"])
        XCTAssertEqual(textBuilder.localize(languageCode: "de", interpolations: DefaultFixtures.interpolations), DefaultFixtures.expectedResults["testHtmlWithInterpolations/de"])
    }
}
