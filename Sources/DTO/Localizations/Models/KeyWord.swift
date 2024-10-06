//
//  KeyWord.swift
//
//
//  Created by Thomas Benninghaus on 26.03.24.
//

import Foundation

public enum KeyWord: Int, CaseIterable, Codable, RawRepresentable {
    case every = 0
    case ev = 1
    case everies = 2
    case day = 3
    case week = 4
    case month = 5
    case quarter = 6
    case year = 7
    case quarterhour = 8
    case hour = 9
    case daily = 10
    case weekly = 11
    case monthly = 12
    case quarteryearly = 13
    case yearly = 14
    case morning = 15
    case noon = 16
    case afternoon = 17
    case evening = 18
    case night = 19
    case workingday = 20
    case weekend = 21
    case ultimo = 22
    case starting = 23
    case from = 24
    case until = 25
    case times = 26
    case forKey = 27
    case at = 28
    case oclock = 29
    case last = 30
    case all = 31
    case allDone = 32
    case everyDone = 33
    case evDone = 34
    case everiesDone = 35
    case quarterhours = 36
    case hours = 37
    case days = 38
    case weeks = 39
    case months = 40
    case quarters = 41
    case years = 42
    case after = 43
    case ending = 44
    case on = 45
    case newyear = 46
    case rosemonday = 47
    case goodfriday = 48
    case eastersunday = 49
    case eastermonday = 50
    case labourday = 51
    case whitsunday = 52
    case whitmonday = 53
    case corpuschristi = 54
    case halloween = 55
    case allsaints = 56
    case christmaseve = 57
    case christmas = 58
    case christmas2 = 59
    case newyearseve = 60
    case one = 61
    case first = 62
    case two = 63
    case second = 64
    case three = 65
    case third = 66
    case four = 67
    case fourth = 68
    case five = 69
    case fifth = 70
    case six = 71
    case sixth = 72
    case seven = 73
    case seventh = 74
    case eight = 75
    case eighth = 76
    case nine = 77
    case ninth = 78
    case ten = 79
    case tenth = 80
    case eleven = 81
    case next = 82
    case twelve = 83
    case nexts = 84
    case thirteen = 85
    case ascensionday = 86
    case fourteen = 87
    case inKey = 88
    case and = 89
    case comma = 90
    
    public var description: String { String(describing: self) }
    public func localizedDescription(localization: (String) -> String) -> String {
        localization(description)
    }
    
    public var keyWordType: KeyWordType {
        return switch self {
            case .ev, .every, .everies, .all: .repeating(false)
            case .evDone, .everyDone, .everiesDone, .allDone: .repeating(true)
            case .quarterhour, .quarterhours: .dateTimeSpan(.quarterHour)
            case .hour, .hours: .dateTimeSpan(.hour)
            case .day, .days, .daily: .dateTimeSpan(.day)
            case .weekend: .typeOfDay(TypeOfDay.weekend)
            case .workingday: .typeOfDay(.workingDay)
            case .newyear, .rosemonday, .goodfriday, .eastersunday, .eastermonday, .labourday, .ascensionday, .whitsunday, .whitmonday, .corpuschristi, .halloween, .allsaints, .christmaseve, .christmas, .christmas2, .newyearseve: .typeOfDay(.holyday(Holyday(rawValue: self.rawValue)!))
            case .week, .weeks, .weekly: .dateTimeSpan(.week)
            case .month, .monthly, .months: .dateTimeSpan(.month)
            case .quarter, .quarters: .dateTimeSpan(.quarter)
            case .year, .yearly, .years: .dateTimeSpan(.year)
            case .quarteryearly: .dateTimeSpan(.quarter)
            case .morning, .noon, .afternoon, .evening, .night: .timeOfDay(TimeOfDay(rawValue: self.rawValue)!)
            case .ultimo, .last: .intName(-1)
            case .starting, .from, .after: .interval(.starting)
            case .until, .ending: .interval(.ending)
            case .times, .forKey: .interval(.length)
            case .at, .oclock: .timeOfDay(.keyWord)
            case .on, .inKey, .next, .nexts: .dateInit
            case .one, .first, .two, .second, .three, .third, .four, .fourth, .five, .fifth, .six, .sixth, .seven, .seventh, .eight, .eighth, .nine, .ninth, .ten, .tenth, .eleven, .twelve, .thirteen, .fourteen: .intName((self.rawValue - 59) / 2)
            case .and, .comma: .listSeparator
            //default: .filler
        }
    }
    
    /*public static var kewordTranslations: Translations {
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
     
    public static var allCases_raw: [String] {
        ["every",
        "ev",
        "everies",
        "day",
        "week",
        "month",
        "quarter",
        "year",
        "quarterhour",
        "hour",
        "daily",
        "weekly",
        "monthly",
        "quarteryearly",
        "yearly",
        "morning",
        "noon",
        "afternoon",
        "evening",
        "night",
        "workingday",
        "weekend",
        "ultimo",
        "starting",
        "from",
        "until",
        "times",
        "forKeyWord",
        "at",
        "oclock",
        "last",
        "all",
        "allDone",
        "everyDone",
        "evDone",
        "everiesDone",
        "quarterhours",
        "hours",
        "days",
        "weeks",
        "months",
        "quarters",
        "years",
        "after",
        "ending",
        "on",
        "newyear",
        "rosemonday",
        "goodfriday",
        "eastersunday",
        "eastermonday",
        "labourday",
        "whitsunday",
        "whitmonday",
        "corpuschristi",
        "halloween",
        "allsaints",
        "christmaseve",
        "christmas",
        "christmas2",
        "newyearseve",
        "one",
        "first",
        "two",
        "second",
        "three",
        "third",
        "four",
        "fourth",
        "five",
        "fifth",
        "six",
        "sixth",
        "seven",
        "seventh",
        "eight",
        "eighth",
        "nine",
        "ninth",
        "ten",
        "tenth",
        "eleven",
        "next",
        "twelve",
        "nexts",
        "thirteen",
        "nextn",
        "fourteen",
        "in",
        "and",
        ","
        ]
    }
    public static var allCases_de: [String] {
        ["jede(.,n,r,s)",
        "xxx1",
        "xxx2",
        "tag",
        "woche",
        "monat",
        "vierteljahr",
        "jahr",
        "viertelstunde",
        "stunde",
        "viertelstündlich",
        "stündlich",
        "täglich",
        "wöchentlich",
        "monatlich",
        "vierteljährlich",
        "jährlich",
        "morgen(.,s)",
        "mittag(.,s)",
        "nachmittag(.,s)",
        "abend(.,s)",
        "nacht(.,s)",
        "werktag(.,s)",
        "wochenende",
        "ultimo",
        "ab",
        "vom",
        "bis",
        "mal",
        "für",
        "um",
        "Uhr",
        "letzten",
        "alle",
        "alle!",
        "jede(.,n,r,s!",
        "xxx1!",
        "xxx2!",
        "viertelstunden",
        "stunden",
        "tage",
        "wochen",
        "monate",
        "vierteljahre",
        "jahre",
        "nach",
        "endend",
        "am",
        "neujahr",
        "rosenmontag",
        "karfreitag",
        "ostersonntag",
        "ostermontag",
        "tag_der_Arbeit",
        "pfingstsonntag",
        "pfingstmontag",
        "fronleichnam",
        "reformationstag",
        "allerheiligen",
        "heiligabend",
        "weihnachten",
        "weihnachten2",
        "silvester",
        "eins",
        "erste",
        "zwei",
        "zweite",
        "drei",
        "dritte",
        "vier",
        "vierte",
        "fünf",
        "fünfte",
        "sechs",
        "sechste",
        "sieben",
        "siebente",
        "acht",
        "achte",
        "neun",
        "neunte",
        "zehn",
        "zehnte",
        "elf",
        "nächste",
        "zwölf",
        "nächstes",
        "dreizehn",
        "nächsten",
        "vierzehn",
        "im",
        "und",
        ","
        ]
    }
    public static var allCases_en: [String] {
        ["every",
        "ev",
        "everies",
        "day",
        "week",
        "month",
        "quarter",
        "year",
        "quarterhour",
        "hour",
        "daily",
        "weekly",
        "monthly",
        "quarteryearly",
        "yearly",
        "morning",
        "noon",
        "afternoon",
        "evening",
        "night",
        "workingday",
        "weekend",
        "ultimo",
        "starting",
        "from",
        "until",
        "times",
        "for",
        "at",
        "o'clock",
        "last",
        "all",
        "all!",
        "every!",
        "ev!",
        "everies!",
        "quarterhours",
        "hours",
        "days",
        "weeks",
        "month",
        "quarters",
        "years",
        "after",
        "ending",
        "on",
        "newyear",
        "rosemonday",
        "goodfriday",
        "eastersunday",
        "eastermonday",
        "labourday",
        "whitsunday",
        "whitmonday",
        "corpuschristi",
        "halloween",
        "allsaints",
        "christmaseve",
        "christmas",
        "christmas2",
        "newyearseve",
        "one",
        "first",
        "two",
        "second",
        "three",
        "third",
        "four",
        "fourth",
        "five",
        "fifth",
        "six",
        "sixth",
        "seven",
        "seventh",
        "eight",
        "eighth",
        "nine",
        "ninth",
        "ten",
        "tenth",
        "eleven",
        "next",
        "twelve",
        "nexts",
        "thirteen",
        "nextn",
        "fourteen",
        "in",
        "and",
        ","
        ]
    }*/
}

public enum KeyWordType {
    case repeating(_ fromCompleted: Bool)
    case dateTimeSpan(_ span: DateComponent)
    case typeOfDay(_ type: TypeOfDay)
    case timeOfDay(_ time: TimeOfDay)
    case intName(_ value: Int)
    case interval(_ type: IntervalKeyword)
    case dateInit
    case listSeparator
    case filler
}

public enum IntervalKeyword {
    case starting, ending, length
}
