//
//  LocalizationMockExtensions.swift
//
//
//  Created by Thomas Benninghaus on 13.05.24.
//
/*
import Foundation
import DTO

extension DatabaseLocalizationRepository: LocalizationRepositoryMockProtocol {
    public static var keywordTranslations: Translations {
        return Translations(translations: [
            //Translation(index: KeyWord.every.rawValue, translatedStrings: ["every", "every", "jede(.,n,r,s)"]),
            //Translation(index: KeyWord.ev.rawValue, translatedStrings: ["ev", "ev", "xxx1"]),
            //Translation(index: KeyWord.everies.rawValue, translatedStrings: ["everies", "everies", "xxx2"]),
            //Translation(index: KeyWord.day.rawValue, translatedStrings: ["day", "day", "tag"]),
            //Translation(index: KeyWord.week.rawValue, translatedStrings: ["week", "week", "woche"]),
            //Translation(index: KeyWord.month.rawValue, translatedStrings: ["month", "month", "monat"]),
            //Translation(index: KeyWord.quarter.rawValue, translatedStrings: ["quarter", "quarter", "vierteljahr"]),
            //Translation(index: KeyWord.year.rawValue, translatedStrings: ["year", "year", "jahr"]),
            //Translation(index: KeyWord.quarterhour.rawValue, translatedStrings: ["quarterhour", "quarterhour", "viertelstunde"]),
            //Translation(index: KeyWord.hour.rawValue, translatedStrings: ["hour", "hour", "stunde"]),
            //Translation(index: KeyWord.daily.rawValue, translatedStrings: ["daily", "daily", "täglich"]),
            //Translation(index: KeyWord.weekly.rawValue, translatedStrings: ["weekly", "weekly", "wöchentlich"]),
            //Translation(index: KeyWord.monthly.rawValue, translatedStrings: ["monthly", "monthly", "monatlich"]),
            //Translation(index: KeyWord.quarteryearly.rawValue, translatedStrings: ["quarteryearly", "quarteryearly", "vierteljährlich"]),
            //Translation(index: KeyWord.yearly.rawValue, translatedStrings: ["yearly", "yearly", "jährlich"]),
            //Translation(index: KeyWord.morning.rawValue, translatedStrings: ["morning", "morning", "morgen(.,s)"]),
            //Translation(index: KeyWord.noon.rawValue, translatedStrings: ["noon", "noon", "mittag(.,s)"]),
            //Translation(index: KeyWord.afternoon.rawValue, translatedStrings: ["afternoon", "afternoon", "nachmittag(.,s)"]),
            //Translation(index: KeyWord.evening.rawValue, translatedStrings: ["evening", "evening", "abend(.,s)"]),
            //Translation(index: KeyWord.night.rawValue, translatedStrings: ["night", "night", "nacht(.,s)"]),
            //Translation(index: KeyWord.workingday.rawValue, translatedStrings: ["workingday", "workingday", "werktag(.,s)"]),
            //Translation(index: KeyWord.weekend.rawValue, translatedStrings: ["weekend", "weekend", "wochenende"]),
            //Translation(index: KeyWord.ultimo.rawValue, translatedStrings: ["ultimo", "ultimo", "ultimo"]),
            //Translation(index: KeyWord.starting.rawValue, translatedStrings: ["starting", "starting", "ab"]),
            //Translation(index: KeyWord.from.rawValue, translatedStrings: ["from", "from", "vo(n,m)"]),
            //Translation(index: KeyWord.until.rawValue, translatedStrings: ["until", "until", "bis"]),
            //Translation(index: KeyWord.times.rawValue, translatedStrings: ["times", "times", "mal"]),
            //Translation(index: KeyWord.forKey.rawValue, translatedStrings: ["forKeyWord", "for", "für"]),
            //Translation(index: KeyWord.at.rawValue, translatedStrings: ["at", "at", "um"]),
            //Translation(index: KeyWord.oclock.rawValue, translatedStrings: ["oclock", "o'clock", "uhr"]),
            //Translation(index: KeyWord.last.rawValue, translatedStrings: ["last", "last", "letzte(.,r)"]),
            //Translation(index: KeyWord.all.rawValue, translatedStrings: ["all", "all", "alle"]),
            //Translation(index: KeyWord.allDone.rawValue, translatedStrings: ["allDone", "all!", "alle!"]),
            //Translation(index: KeyWord.everyDone.rawValue, translatedStrings: ["everyDone", "every!", "jede(!,n!,r!,s!)"]),
            //Translation(index: KeyWord.evDone.rawValue, translatedStrings: ["evDone", "ev!", "xxx1!"]),
            //Translation(index: KeyWord.everiesDone.rawValue, translatedStrings: ["everiesDone", "everies!", "xxx2!"]),
            //Translation(index: KeyWord.quarterhours.rawValue, translatedStrings: ["quarterhours", "quarterhours", "viertelstunden"]),
            //Translation(index: KeyWord.hours.rawValue, translatedStrings: ["hours", "hours", "stunden"]),
            //Translation(index: KeyWord.days.rawValue, translatedStrings: ["days", "days", "tage"]),
            //Translation(index: KeyWord.weeks.rawValue, translatedStrings: ["weeks", "weeks", "wochen"]),
            //Translation(index: KeyWord.months.rawValue, translatedStrings: ["months", "months", "monate"]),
            //Translation(index: KeyWord.quarters.rawValue, translatedStrings: ["quarters", "quarters", "vierteljahre"]),
            //Translation(index: KeyWord.years.rawValue, translatedStrings: ["years", "years", "jahre"]),
            //Translation(index: KeyWord.after.rawValue, translatedStrings: ["after", "after", "nach"]),
            //Translation(index: KeyWord.ending.rawValue, translatedStrings: ["ending", "ending", "endend"]),
            //Translation(index: KeyWord.on.rawValue, translatedStrings: ["on", "on", "am"]),
            //Translation(index: KeyWord.newyear.rawValue, translatedStrings: ["newyear", "newyear", "neujahr"]),
            //Translation(index: KeyWord.rosemonday.rawValue, translatedStrings: ["rosemonday", "rosemonday", "rosenmontag"]),
            //Translation(index: KeyWord.goodfriday.rawValue, translatedStrings: ["goodfriday", "goodfriday", "karfreitag"]),
            //Translation(index: KeyWord.eastersunday.rawValue, translatedStrings: ["eastersunday", "eastersunday", "ostersonntag"]),
            //Translation(index: KeyWord.eastermonday.rawValue, translatedStrings: ["eastermonday", "eastermonday", "ostermontag"]),
            //Translation(index: KeyWord.labourday.rawValue, translatedStrings: ["labourday", "labourday", "tag_der_arbeit"]),
            //Translation(index: KeyWord.whitsunday.rawValue, translatedStrings: ["whitsunday", "whitsunday", "pfingstsonntag"]),
            //Translation(index: KeyWord.whitmonday.rawValue, translatedStrings: ["whitmonday", "whitmonday", "pfingstmontag"]),
            //Translation(index: KeyWord.corpuschristi.rawValue, translatedStrings: ["corpuschristi", "corpuschristi", "fronleichnam"]),
            //Translation(index: KeyWord.halloween.rawValue, translatedStrings: ["halloween", "halloween", "reformationstag"]),
            //Translation(index: KeyWord.allsaints.rawValue, translatedStrings: ["allsaints", "allsaints", "allerheiligen"]),
            //Translation(index: KeyWord.christmaseve.rawValue, translatedStrings: ["christmaseve", "christmaseve", "heiligabend"]),
            //Translation(index: KeyWord.christmas.rawValue, translatedStrings: ["christmas", "christmas", "1.weihnachten"]),
            //Translation(index: KeyWord.christmas2.rawValue, translatedStrings: ["christmas2", "christmas2", "2.weihnachten"]),
            //Translation(index: KeyWord.newyearseve.rawValue, translatedStrings: ["newyearseve", "newyearseve", "sylvester"]),
            //Translation(index: KeyWord.one.rawValue, translatedStrings: ["one", "one", "eins"]),
            //Translation(index: KeyWord.first.rawValue, translatedStrings: ["first", "first", "erste(.,n,r)"]),
            //Translation(index: KeyWord.two.rawValue, translatedStrings: ["two", "two", "zwei"]),
            //Translation(index: KeyWord.second.rawValue, translatedStrings: ["second", "second", "zweite(.,n,r)"]),
            //Translation(index: KeyWord.three.rawValue, translatedStrings: ["three", "three", "drei"]),
            //Translation(index: KeyWord.third.rawValue, translatedStrings: ["third", "third", "dritte(.,n,r)"]),
            //Translation(index: KeyWord.four.rawValue, translatedStrings: ["four", "four", "vier"]),
            //Translation(index: KeyWord.fourth.rawValue, translatedStrings: ["fourth", "fourth", "vierte(.,n,r)"]),
            //Translation(index: KeyWord.five.rawValue, translatedStrings: ["five", "five", "fünf"]),
            //Translation(index: KeyWord.fifth.rawValue, translatedStrings: ["fifth", "fifth", "fünfte(.,n,r)"]),
            //Translation(index: KeyWord.six.rawValue, translatedStrings: ["six", "six", "sechs"]),
            //Translation(index: KeyWord.sixth.rawValue, translatedStrings: ["sixth", "sixth", "sechste(.,n,r)"]),
            //Translation(index: KeyWord.seven.rawValue, translatedStrings: ["seven", "seven", "sieben"]),
            //Translation(index: KeyWord.seventh.rawValue, translatedStrings: ["seventh", "seventh", "siebte(.,n,r)"]),
            //Translation(index: KeyWord.eight.rawValue, translatedStrings: ["eight", "eight", "acht"]),
            //Translation(index: KeyWord.eighth.rawValue, translatedStrings: ["eighth", "eighth", "achte(.,n,r)"]),
            //Translation(index: KeyWord.nine.rawValue, translatedStrings: ["nine", "nine", "neun"]),
            //Translation(index: KeyWord.ninth.rawValue, translatedStrings: ["ninth", "ninth", "neunte(.,n,r)"]),
            //Translation(index: KeyWord.ten.rawValue, translatedStrings: ["ten", "ten", "zehn"]),
            //Translation(index: KeyWord.tenth.rawValue, translatedStrings: ["tenth", "tenth", "zehnte(.,n,r)"]),
            //Translation(index: KeyWord.eleven.rawValue, translatedStrings: ["eleven", "eleven", "elf"]),
            //Translation(index: KeyWord.next.rawValue, translatedStrings: ["next", "next", "nächste(.,n,r)"]),
            //Translation(index: KeyWord.twelve.rawValue, translatedStrings: ["twelve", "twelve", "zwölf"]),
            //Translation(index: KeyWord.nexts.rawValue, translatedStrings: ["nexts", "nexts", "nächstes"]),
            //Translation(index: KeyWord.thirteen.rawValue, translatedStrings: ["thirteen", "thirteen", "dreizehn"]),
            //Translation(index: KeyWord.ascensionday.rawValue, translatedStrings: ["ascensionday", "ascensionday", "christihimmelfahrt"]),
            //Translation(index: KeyWord.fourteen.rawValue, translatedStrings: ["fourteen", "fourteen", "vierzehn"]),
            //Translation(index: KeyWord.inKey.rawValue, translatedStrings: ["inkey", "in", "in"]),
            //Translation(index: KeyWord.and .rawValue, translatedStrings: ["and", "and", "und"]),
            //Translation(index: KeyWord.comma.rawValue, translatedStrings: ["comma", ",", ","])
        ])
    }
    
    public static func loadLocalizations(atPath path: String) throws -> [String: String] {
        let fileContent = try Data(contentsOf: URL(fileURLWithPath: path))
        let jsonObject = try JSONSerialization.jsonObject(with: fileContent, options: [])
        guard let localizations = jsonObject as? [String: String] else { throw LocalizationControllerError.parsingFailure(message: "Invalid localization file format at path: \(path). Expected string indexed dictionary at the root level.") }
        return localizations
    }
}
*/
