//
//  DefaultFixtures.swift
//  
//
//  Created by Thomas Benninghaus on 06.01.24.
//

import Foundation

/// Since it is not possible to include any resources with SPM, this class will generate them.
/// In Swift4 we can use multiline string literals for JSON file fixtures.
class DefaultFixtures {
    
    public static func setup(atPath path: String) throws {
        try FileManager().createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        
        try self.enLocalizations.write(toFile: path + "/en.json", atomically: true, encoding: .utf8)
        try self.enLocalizations.write(toFile: path + "/en-XX.json", atomically: true, encoding: .utf8)
        try self.deLocalizations.write(toFile: path + "/de.json", atomically: true, encoding: .utf8)
    }
    
    private static var enLocalizations: String {
        return
"{" +
    "\"hello.world\": \"Hello World!\"," +
    "\"unread.messages\": {" +
        "\"one\": \"You have an unread message.\"," +
        "\"other\": \"You have %{unread-messages-count} unread messages.\"" +
    "}," +
       "\"hello.recipient\": \"Hello %{recipientName} (%{recipientEmail})\"," +
       "\"hello.recipientFix\": \"Hello René Rüßtig (ruesstig@test.de)\"," +
       "\"resetpasswordemail.body\": \"Thank you for registering Reminders for MacOS! %{recipientName} from Reminders for MacOS Team: %{verify_url}\"," +
       "\"resetpasswordemail.bodyFix\": \"Thank you for registering Reminders for MacOS! René Rüßtig from Reminders for MacOS Team: http://t-benninghaus.de/token=24234343\"," +
"}"
    }
    
    private static var deLocalizations: String {
        return
"{" +
    "\"hello.world\": \"Hallo Welt!\"," +
    "\"unread.messages\": {" +
        "\"one\": \"Du hast eine ungelesene Nachricht.\"," +
        "\"other\": \"Du hast %{unread-messages-count} ungelesene Nachrichten.\"" +
    "}," +
        "\"hello.recipient\": \"Hallo %{recipientName} (%{recipientEmail})\"," +
        "\"hello.recipientFix\": \"Hallo René Rüßtig (ruesstig@test.de)\"," +
        "\"resetpasswordemail.body\": \"Vielen Dank für Ihre Rgistrierung zu Reminders für MacOS! %{recipientName} von Reminders für MacOS Team: %{verify_url}\"," +
        "\"resetpasswordemail.bodyFix\": \"Vielen Dank für Ihre Rgistrierung zu Reminders für MacOS! René Rüßtig from Reminders für MacOS Team: http://t-benninghaus.de/token=24234343\"," +
"}"
    }
    
    public static var interpolations: [String: String] = [
        "verify_url": "http://t-benninghaus.de/token=24234343",
        "recipientName": "René Rüßtig",
        "nonsens": "nonstopnonsens",
        "recipientEmail": "ruesstig@test.de"
    ]
    
    public static var testText: String {
        return "${hello.recipientFix} und Herr Müller,\n${resetpasswordemail.bodyFix}"
    }
    
    public static var testTextWithInterpolations: String {
        return "${hello.recipient} und Herr Müller,\n${resetpasswordemail.body}"
    }
    
    public static var testHtml: String {
        return "<html><p style=3D\"color: rgb(119, 119, 119); margin: 0px; text-align: left; font-size: 14px; line-height: 19px;\">${hello.recipientFix},<br><br>${resetpasswordemail.bodyFix}<br></html>"
    }
    
    public static var testHtmlWithInterpolations: String {
        return "<html><p style=3D\"color: rgb(119, 119, 119); margin: 0px; text-align: left; font-size: 14px; line-height: 19px;\">${hello.recipient},<br><br>${resetpasswordemail.body}<br></html>"
    }
    
    public static var expectedResults: [String: String] {
        return [
            "testText/de": "Hallo René Rüßtig (ruesstig@test.de) und Herr Müller,\nVielen Dank für Ihre Rgistrierung zu Reminders für MacOS! René Rüßtig from Reminders für MacOS Team: http://t-benninghaus.de/token=24234343",
            "testText/en": "Hello René Rüßtig (ruesstig@test.de) und Herr Müller,\nThank you for registering Reminders for MacOS! René Rüßtig from Reminders for MacOS Team: http://t-benninghaus.de/token=24234343",
            "testTextWithInterpolations/de": "Hallo René Rüßtig (ruesstig@test.de) und Herr Müller,\nVielen Dank für Ihre Rgistrierung zu Reminders für MacOS! René Rüßtig von Reminders für MacOS Team: http://t-benninghaus.de/token=24234343",
            "testTextWithInterpolations/en": "Hello René Rüßtig (ruesstig@test.de) und Herr Müller,\nThank you for registering Reminders for MacOS! René Rüßtig from Reminders for MacOS Team: http://t-benninghaus.de/token=24234343",
            "testHtml/de": "<html><p style=3D\"color: rgb(119, 119, 119); margin: 0px; text-align: left; font-size: 14px; line-height: 19px;\">Hallo Ren&#xE9; R&#xFC;&#xDF;tig (ruesstig@test.de),<br><br>Vielen Dank f&#xFC;r Ihre Rgistrierung zu Reminders f&#xFC;r MacOS! Ren&#xE9; R&#xFC;&#xDF;tig from Reminders f&#xFC;r MacOS Team: http://t-benninghaus.de/token=24234343<br></html>",
            "testHtml/en": "<html><p style=3D\"color: rgb(119, 119, 119); margin: 0px; text-align: left; font-size: 14px; line-height: 19px;\">Hello Ren&#xE9; R&#xFC;&#xDF;tig (ruesstig@test.de),<br><br>Thank you for registering Reminders for MacOS! Ren&#xE9; R&#xFC;&#xDF;tig from Reminders for MacOS Team: http://t-benninghaus.de/token=24234343<br></html>",
            "testHtmlWithInterpolations/de": "<html><p style=3D\"color: rgb(119, 119, 119); margin: 0px; text-align: left; font-size: 14px; line-height: 19px;\">Hallo Ren&#xE9; R&#xFC;&#xDF;tig (ruesstig@test.de),<br><br>Vielen Dank f&#xFC;r Ihre Rgistrierung zu Reminders f&#xFC;r MacOS! Ren&#xE9; R&#xFC;&#xDF;tig von Reminders f&#xFC;r MacOS Team: http://t-benninghaus.de/token=24234343<br></html>",
            "testHtmlWithInterpolations/en": "<html><p style=3D\"color: rgb(119, 119, 119); margin: 0px; text-align: left; font-size: 14px; line-height: 19px;\">Hello Ren&#xE9; R&#xFC;&#xDF;tig (ruesstig@test.de),<br><br>Thank you for registering Reminders for MacOS! Ren&#xE9; R&#xFC;&#xDF;tig from Reminders for MacOS Team: http://t-benninghaus.de/token=24234343<br></html>"
        ]
    }
}
