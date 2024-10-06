//
//  BasicDataModels.swift
//
//
//  Created by Thomas Benninghaus on 17.05.24.
//

import Foundation
import DTO
import Resources
import Vapor

public final class BasicDataModels {
    public static var mock: BasicDataModels = BasicDataModels()
    
    public var users: [(UserModel, UserDataModels)]
    public var countries: [CountryModel]
    public var locations: [LocationModel]
    public var locales: [LocaleModel]
    public var countryLocales: [CountryLocale]
    public var languages: [LanguageModel]
    public var localizations: [LocalizationModel]
    
    public init(users models: [(UserModel, UserDataModels)]? = nil, countries: [CountryModel]? = nil, locations: [LocationModel]? = nil, locales: [LocaleModel]? = nil, countryLocales: [CountryLocale]? = nil, languages: [LanguageModel]? = nil, localizations: [LocalizationModel]? = nil, keywords: [LocalizationModel]? = nil) {
        self.users = models ?? [(userMock, UserDataModels(userId: userMock.id!))]
        self.countries = countries ?? countriesMock
        self.locations = locations ?? locationsMock
        self.locales = locales ?? localesMock
        self.countryLocales = countryLocales ?? countryLocalesMock
        self.languages = languages ?? languagesMock
        self.localizations = localizations ?? localizationsMock
        self.localizations
            .append(contentsOf: keywords ?? keywordsMock)
    }

    static let uuids: [UUID] = [0...57].map { int in UUID()}
    private var userMock: UserModel = {
        let password = "abcd1234"
        let passwordHash = try? Bcrypt.hash(password)
        return UserModel(id: uuids[35], fullName: "Default User", email: "defaultuser@test.com", passwordHash: passwordHash!, isAdmin: false, isEmailVerified: true, imageURL: nil, localeId: uuids[2], locationId: uuids[20])
    }()
    private var countriesMock: [CountryModel] = [
        CountryModel(id: uuids[56], description: "notSet", identifier: "raw", defaultLocaleId: uuids[8]),
        CountryModel(id: uuids[0], description: "germany", identifier: "germany", defaultLocaleId: uuids[1]),
        CountryModel(id: uuids[2], description: "greatbritain", identifier: "greatbritain", defaultLocaleId: uuids[3]),
        CountryModel(id: uuids[4], description: "unitedstates", identifier: "unitedstates", defaultLocaleId: uuids[5]),
        CountryModel(id: uuids[6], description: "france", identifier: "france", defaultLocaleId: uuids[7]),
        CountryModel(id: uuids[29], description: "southafrica", identifier: "southafrica", defaultLocaleId: uuids[3]),
        CountryModel(id: uuids[36], description: "italy", identifier: "italy", defaultLocaleId: uuids[38]),
        CountryModel(id: uuids[37], description: "switzerland", identifier: "switzerland", defaultLocaleId: uuids[1]),
        CountryModel(id: uuids[45], description: "netherlands", identifier: "netherlands", defaultLocaleId: uuids[33])
    ]
    private var locationsMock: [LocationModel] = [
        LocationModel(id: uuids[57], countryId: uuids[56], description: "notSet", identifier: "raw", timeZone: "Europe/London"),
        LocationModel(id: uuids[18], countryId: uuids[0], description: "Berlin", identifier: "berlin", timeZone: "Europe/Berlin"),
        LocationModel(id: uuids[19], countryId: uuids[0], description: "Köln", identifier: "cologne", timeZone: "Europe/Berlin"),
        LocationModel(id: uuids[20], countryId: uuids[2], description: "London", identifier: "london", timeZone: "Europe/London"),
        LocationModel(id: uuids[21], countryId: uuids[4], description: "New York", identifier: "newyork", timeZone: "America/New_York"),
        LocationModel(id: uuids[22], countryId: uuids[4], description: "Los Angeles", identifier: "losangeles", timeZone: "America/Los_Angeles"),
        LocationModel(id: uuids[23], countryId: uuids[4], description: "Chicago", identifier: "chicago", timeZone: "America/Chicago"),
        LocationModel(id: uuids[24], countryId: uuids[6], description: "Paris", identifier: "paris", timeZone: "Europe/Paris"),
        LocationModel(id: uuids[25], countryId: uuids[4], description: "Hawaii", identifier: "hawaii", timeZone: "America/Hawaii"),
        LocationModel(id: uuids[26], countryId: uuids[4], description: "Anchorage", identifier: "anchorage", timeZone: "America/Anchorage"),
        LocationModel(id: uuids[27], countryId: uuids[4], description: "Denver", identifier: "denver", timeZone: "America/Denver"),
        LocationModel(id: uuids[28], countryId: uuids[29], description: "Johannesburg", identifier: "johannesburg", timeZone: "Afrika/Johannesburg"),
        LocationModel(id: uuids[46], countryId: uuids[36], description: "Rome", identifier: "rome", timeZone: "Europe/Rome"),
        LocationModel(id: uuids[47], countryId: uuids[45], description: "Amsterdam", identifier: "amsterdam", timeZone: "Europe/Amsterdam"),
        LocationModel(id: uuids[48], countryId: uuids[37], description: "Genf", identifier: "geneve", timeZone: "Europe/Geneve")
    ]
    private var localesMock: [LocaleModel] = [
        LocaleModel(id: uuids[3], name: "en_GB", identifier: .en_GB, longName: "English (GB)", dateSeparator: "/", standardDateSequence: [.day, .month, .year], dateSequence: [.day, .week, .month, .year], languageId: uuids[10]),
        LocaleModel(id: uuids[5], name: "en_US", identifier: .en_US, longName: "English (US)", dateSeparator: "/", standardDateSequence: [.month, .day, .year], dateSequence: [.month, .day, .week, .year], languageId: uuids[10]),
        LocaleModel(id: uuids[1], name: "de_DE", identifier: .de_DE, longName: "Deutsch", dateSeparator: ".", standardDateSequence: [.day, .month, .year], dateSequence: [.day, .week, .month, .year], languageId: uuids[12]),
        LocaleModel(id: uuids[7], name: "fr_FR", identifier: .fr_FR, longName: "Francaise", dateSeparator: ".", standardDateSequence: [.day, .month, .year], dateSequence: [.day, .week, .month, .year], languageId: uuids[14]),
        LocaleModel(id: uuids[33], name: "nl_NL", identifier: .nl_NL, longName: "Nederlands", dateSeparator: ".", standardDateSequence: [.day, .month, .year], dateSequence: [.day, .week, .month, .year], languageId: uuids[9]),
        LocaleModel(id: uuids[49], name: "nl_ZA", identifier: .nl_ZA, longName: "Nederlands (ZA)", dateSeparator: ".", standardDateSequence: [.day, .month, .year], dateSequence: [.day, .week, .month, .year], languageId: uuids[9]),
        LocaleModel(id: uuids[34], name: "af_ZA", identifier: .af_ZA, longName: "Afrikaans", dateSeparator: ".", standardDateSequence: [.day, .month, .year], dateSequence: [.day, .week, .month, .year], languageId: uuids[11]),
        LocaleModel(id: uuids[53], name: "en_ZA", identifier: .en_ZA, longName: "English (ZA)", dateSeparator: "/", standardDateSequence: [.day, .month, .year], dateSequence: [.day, .week, .month, .year], languageId: uuids[10]),
        LocaleModel(id: uuids[38], name: "it_IT", identifier: .it_IT, longName: "Italiano", dateSeparator: ".", standardDateSequence: [.day, .month, .year], dateSequence: [.day, .week, .month, .year], languageId: uuids[39]),
        LocaleModel(id: uuids[50], name: "de_CH", identifier: .de_CH, longName: "Deutsch (CH)", dateSeparator: ".", standardDateSequence: [.day, .month, .year], dateSequence: [.day, .week, .month, .year], languageId: uuids[12]),
        LocaleModel(id: uuids[51], name: "fr_CH", identifier: .fr_CH, longName: "Francaise (CH)", dateSeparator: ".", standardDateSequence: [.day, .month, .year], dateSequence: [.day, .week, .month, .year], languageId: uuids[14]),
        LocaleModel(id: uuids[52], name: "it_CH", identifier: .it_CH, longName: "Italiano (CH)", dateSeparator: ".", standardDateSequence: [.day, .month, .year], dateSequence: [.day, .week, .month, .year], languageId: uuids[39]),
       LocaleModel(id: uuids[16], name: "raw", identifier: .notSet, longName: "Not Set", dateSeparator: "-", standardDateSequence:  [.year, .month, .week, .day], dateSequence: [.year, .month, .week, .day], languageId: uuids[8])
    ]
    private var countryLocalesMock: [CountryLocale] = [
        CountryLocale(id: uuids[13], countryId: uuids[0], localeId: uuids[1]),
        CountryLocale(id: uuids[15], countryId: uuids[2], localeId: uuids[3]),
        CountryLocale(id: uuids[17], countryId: uuids[4], localeId: uuids[5]),
        CountryLocale(id: uuids[30], countryId: uuids[6], localeId: uuids[7]),
        CountryLocale(id: uuids[31], countryId: uuids[29], localeId: uuids[49]),
        CountryLocale(id: uuids[32], countryId: uuids[29], localeId: uuids[53]),
        CountryLocale(id: uuids[44], countryId: uuids[29], localeId: uuids[34]),
        CountryLocale(id: uuids[40], countryId: uuids[36], localeId: uuids[38]),
        CountryLocale(id: uuids[41], countryId: uuids[37], localeId: uuids[50]),
        CountryLocale(id: uuids[42], countryId: uuids[37], localeId: uuids[51]),
        CountryLocale(id: uuids[43], countryId: uuids[37], localeId: uuids[52]),
        CountryLocale(id: uuids[44], countryId: uuids[45], localeId: uuids[33]),
        CountryLocale(id: uuids[55], countryId: uuids[56], localeId: uuids[8])
    ]
    private var languagesMock: [LanguageModel] = [
        LanguageModel(id: uuids[8], name: "NotSet", identifier: .notSet, longName: "Not Set"),
        LanguageModel(id: uuids[10], name: "English", identifier: .en, longName: "English"),
        LanguageModel(id: uuids[12], name: "Deutsch", identifier: .de, longName: "Deutsch"),
        LanguageModel(id: uuids[14], name: "Francaise", identifier: .fr, longName: "Francaise"),
        LanguageModel(id: uuids[9], name: "Nederlands", identifier: .nl, longName: "Nederlands"),
        LanguageModel(id: uuids[11], name: "Afrikaans", identifier: .af, longName: "Afrikaans"),
        LanguageModel(id: uuids[39], name: "Italiano", identifier: .it, longName: "Italiano")
    ]
    private var localizationsMock: [LocalizationModel] = {
        var localizations: [LocalizationModel] = []
        return try! ["en", "de"]
            .reduce(localizations) { result, locale in
                try BasicDataModels.loadLocalizations(atPath: "\(ResourcePaths.localizationsPath.path)/\(locale).json")
                    .map { (key, object) in
                        // Parse localizations. Note that valid `object` in the for-loop can be either:
                        // - a String, in case there are no pluralizations defined (one, few, many, other,..)
                        // - a dictionary [String: String], in case pluralizations are defined
                        if let stringValue = object as? String {
                            return LocalizationModel(id: UUID(), languageModel: .languages, languageCode: locale, enumKey: nil, key: key, value: stringValue)
                        } else if let rawPluralizedValues = object as? [String: String] {
                            return LocalizationModel(id: UUID(), languageModel: .languages, languageCode: locale, enumKey: nil, key: key, value: nil, pluralized: rawPluralizedValues)
                        } else {
                            throw LocalizationControllerError.parsingFailure(message: "Unsupported pluralization format for key: \(key).")
                        }
                    }
            }
    }()
    private var keywordsMock: [LocalizationModel] = [
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.every, key: "keywords.\(KeyWord.every.description)", value: KeyWord.every.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.every, key: "keywords.\(KeyWord.every.description)", value: "every"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.every, key: "keywords.\(KeyWord.every.description)", value: "jede(.,n,r,s)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.ev, key: "keywords.\(KeyWord.ev.description)", value: KeyWord.ev.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.ev, key: "keywords.\(KeyWord.ev.description)", value: "ev"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.ev, key: "keywords.\(KeyWord.ev.description)", value: "j"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.day, key: "keywords.\(KeyWord.day.description)", value: KeyWord.day.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.day, key: "keywords.\(KeyWord.day.description)", value: "day"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.day, key: "keywords.\(KeyWord.day.description)", value: "tag"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.week, key: "keywords.\(KeyWord.week.description)", value: KeyWord.week.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.week, key: "keywords.\(KeyWord.week.description)", value: "week"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.week, key: "keywords.\(KeyWord.week.description)", value: "woche"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.month, key: "keywords.\(KeyWord.month.description)", value: KeyWord.month.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.month, key: "keywords.\(KeyWord.month.description)", value: "month"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.month, key: "keywords.\(KeyWord.month.description)", value: "monat"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.quarter, key: "keywords.\(KeyWord.quarter.description)", value: KeyWord.quarter.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.quarter, key: "keywords.\(KeyWord.quarter.description)", value: "quarter"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.quarter, key: "keywords.\(KeyWord.quarter.description)", value: "quartal"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.year, key: "keywords.\(KeyWord.year.description)", value: KeyWord.year.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.year, key: "keywords.\(KeyWord.year.description)", value: "year"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.year, key: "keywords.\(KeyWord.year.description)", value: "jahr)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.quarterhour, key: "keywords.\(KeyWord.quarterhour.description)", value: KeyWord.quarterhour.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.quarterhour, key: "keywords.\(KeyWord.quarterhour.description)", value: "quarterhour"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.quarterhour, key: "keywords.\(KeyWord.quarterhour.description)", value: "viertelstunde"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.hour, key: "keywords.\(KeyWord.hour.description)", value: KeyWord.hour.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.hour, key: "keywords.\(KeyWord.hour.description)", value: "hour"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.hour, key: "keywords.\(KeyWord.hour.description)", value: "stunde"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.daily, key: "keywords.\(KeyWord.daily.description)", value: KeyWord.daily.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.daily, key: "keywords.\(KeyWord.daily.description)", value: "daily"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.daily, key: "keywords.\(KeyWord.daily.description)", value: "täglich"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.weekly, key: "keywords.\(KeyWord.weekly.description)", value: KeyWord.weekly.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.weekly, key: "keywords.\(KeyWord.weekly.description)", value: "weekly"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.weekly, key: "keywords.\(KeyWord.weekly.description)", value: "wöchentlich"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.monthly, key: "keywords.\(KeyWord.monthly.description)", value: KeyWord.monthly.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.monthly, key: "keywords.\(KeyWord.monthly.description)", value: "monthly"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.monthly, key: "keywords.\(KeyWord.monthly.description)", value: "monatlich"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.quarteryearly, key: "keywords.\(KeyWord.quarteryearly.description)", value: KeyWord.quarteryearly.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.quarteryearly, key: "keywords.\(KeyWord.quarteryearly.description)", value: "quarteryearly"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.quarteryearly, key: "keywords.\(KeyWord.quarteryearly.description)", value: "vierteljährlich"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.yearly, key: "keywords.\(KeyWord.yearly.description)", value: KeyWord.yearly.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.yearly, key: "keywords.\(KeyWord.yearly.description)", value: "yearly"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.yearly, key: "keywords.\(KeyWord.yearly.description)", value: "jährlich"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.morning, key: "keywords.\(KeyWord.morning.description)", value: KeyWord.morning.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.morning, key: "keywords.\(KeyWord.morning.description)", value: "morning"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.morning, key: "keywords.\(KeyWord.morning.description)", value: "morgen(.,s)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.noon, key: "keywords.\(KeyWord.noon.description)", value: KeyWord.noon.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.noon, key: "keywords.\(KeyWord.noon.description)", value: "noon"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.noon, key: "keywords.\(KeyWord.noon.description)", value: "mittag(.,s)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.afternoon, key: "keywords.\(KeyWord.afternoon.description)", value: KeyWord.afternoon.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.afternoon, key: "keywords.\(KeyWord.afternoon.description)", value: "afternoon"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.afternoon, key: "keywords.\(KeyWord.afternoon.description)", value: "nachmittag(.,s)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.evening, key: "keywords.\(KeyWord.evening.description)", value: KeyWord.evening.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.evening, key: "keywords.\(KeyWord.evening.description)", value: "evening"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.evening, key: "keywords.\(KeyWord.evening.description)", value: "abend(.,s)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.night, key: "keywords.\(KeyWord.night.description)", value: KeyWord.night.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.night, key: "keywords.\(KeyWord.night.description)", value: "night"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.night, key: "keywords.\(KeyWord.night.description)", value: "nacht(.,s)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.workingday, key: "keywords.\(KeyWord.workingday.description)", value: KeyWord.workingday.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.workingday, key: "keywords.\(KeyWord.workingday.description)", value: "workingday"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.workingday, key: "keywords.\(KeyWord.workingday.description)", value: "werktag(.,s)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.weekend, key: "keywords.\(KeyWord.weekend.description)", value: KeyWord.weekend.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.weekend, key: "keywords.\(KeyWord.weekend.description)", value: "weekend"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.weekend, key: "keywords.\(KeyWord.weekend.description)", value: "wochenende"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.ultimo, key: "keywords.\(KeyWord.ultimo.description)", value: KeyWord.ultimo.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.ultimo, key: "keywords.\(KeyWord.ultimo.description)", value: "ultimo"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.ultimo, key: "keywords.\(KeyWord.ultimo.description)", value: "ultimo"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.starting, key: "keywords.\(KeyWord.starting.description)", value: KeyWord.starting.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.starting, key: "keywords.\(KeyWord.starting.description)", value: "starting"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.starting, key: "keywords.\(KeyWord.starting.description)", value: "ab"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.from, key: "keywords.\(KeyWord.from.description)", value: KeyWord.from.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.from, key: "keywords.\(KeyWord.from.description)", value: "from"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.from, key: "keywords.\(KeyWord.from.description)", value: "vo(n,m)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.until, key: "keywords.\(KeyWord.until.description)", value: KeyWord.until.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.until, key: "keywords.\(KeyWord.until.description)", value: "until"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.until, key: "keywords.\(KeyWord.until.description)", value: "bis"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.times, key: "keywords.\(KeyWord.times.description)", value: KeyWord.times.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.times, key: "keywords.\(KeyWord.times.description)", value: "times"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.times, key: "keywords.\(KeyWord.times.description)", value: "mal"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.forKey, key: "keywords.\(KeyWord.forKey.description)", value: "forKeyWord"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.forKey, key: "keywords.\(KeyWord.forKey.description)", value: "for"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.forKey, key: "keywords.\(KeyWord.forKey.description)", value: "für"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.at, key: "keywords.\(KeyWord.at.description)", value: KeyWord.at.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.at, key: "keywords.\(KeyWord.at.description)", value: "at"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.at, key: "keywords.\(KeyWord.at.description)", value: "um"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.oclock, key: "keywords.\(KeyWord.oclock.description)", value: KeyWord.oclock.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.oclock, key: "keywords.\(KeyWord.oclock.description)", value: "o'clock"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.oclock, key: "keywords.\(KeyWord.oclock.description)", value: "uhr"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.last, key: "keywords.\(KeyWord.last.description)", value: KeyWord.last.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.last, key: "keywords.\(KeyWord.last.description)", value: "last"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.last, key: "keywords.\(KeyWord.last.description)", value: "letzte(.,n,r)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.all, key: "keywords.\(KeyWord.all.description)", value: KeyWord.all.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.all, key: "keywords.\(KeyWord.all.description)", value: "all"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.all, key: "keywords.\(KeyWord.all.description)", value: "alle"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.allDone, key: "keywords.\(KeyWord.allDone.description)", value: KeyWord.allDone.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.allDone, key: "keywords.\(KeyWord.allDone.description)", value: "all!"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.allDone, key: "keywords.\(KeyWord.allDone.description)", value: "alle(!, n!)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.everyDone, key: "keywords.\(KeyWord.everyDone.description)", value: KeyWord.everyDone.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.everyDone, key: "keywords.\(KeyWord.everyDone.description)", value: "every!"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.everyDone, key: "keywords.\(KeyWord.everyDone.description)", value: "jede(!,n!,r!,s!)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.evDone, key: "keywords.\(KeyWord.evDone.description)", value: KeyWord.evDone.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.evDone, key: "keywords.\(KeyWord.evDone.description)", value: "ev!"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.evDone, key: "keywords.\(KeyWord.evDone.description)", value: "j!"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.quarterhours, key: "keywords.\(KeyWord.quarterhours.description)", value: KeyWord.quarterhours.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.quarterhours, key: "keywords.\(KeyWord.quarterhours.description)", value: "quarterhours"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.quarterhours, key: "keywords.\(KeyWord.quarterhours.description)", value: "viertelstunde(.,n)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.hours, key: "keywords.\(KeyWord.hours.description)", value: KeyWord.hours.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.hours, key: "keywords.\(KeyWord.hours.description)", value: "hours"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.hours, key: "keywords.\(KeyWord.hours.description)", value: "stunden"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.days, key: "keywords.\(KeyWord.days.description)", value: KeyWord.days.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.days, key: "keywords.\(KeyWord.days.description)", value: "days"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.days, key: "keywords.\(KeyWord.days.description)", value: "tage"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.weeks, key: "keywords.\(KeyWord.weeks.description)", value: KeyWord.weeks.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.weeks, key: "keywords.\(KeyWord.weeks.description)", value: "weeks"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.weeks, key: "keywords.\(KeyWord.weeks.description)", value: "wochen"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.months, key: "keywords.\(KeyWord.months.description)", value: KeyWord.months.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.months, key: "keywords.\(KeyWord.months.description)", value: "months"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.months, key: "keywords.\(KeyWord.months.description)", value: "monate"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.quarters, key: "keywords.\(KeyWord.quarters.description)", value: KeyWord.quarters.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.quarters, key: "keywords.\(KeyWord.quarters.description)", value: "quarters"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.quarters, key: "keywords.\(KeyWord.quarters.description)", value: "vierteljahre"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.years, key: "keywords.\(KeyWord.years.description)", value: KeyWord.years.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.years, key: "keywords.\(KeyWord.years.description)", value: "years"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.years, key: "keywords.\(KeyWord.years.description)", value: "jahre"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.after, key: "keywords.\(KeyWord.after.description)", value: KeyWord.after.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.after, key: "keywords.\(KeyWord.after.description)", value: "after"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.after, key: "keywords.\(KeyWord.after.description)", value: "nach"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.ending, key: "keywords.\(KeyWord.ending.description)", value: KeyWord.ending.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.ending, key: "keywords.\(KeyWord.ending.description)", value: "ending"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.ending, key: "keywords.\(KeyWord.ending.description)", value: "endend"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.on, key: "keywords.\(KeyWord.on.description)", value: KeyWord.on.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.on, key: "keywords.\(KeyWord.on.description)", value: "on"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.on, key: "keywords.\(KeyWord.on.description)", value: "am"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.newyear, key: "keywords.\(KeyWord.newyear.description)", value: KeyWord.newyear.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.newyear, key: "keywords.\(KeyWord.newyear.description)", value: "newyear"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.newyear, key: "keywords.\(KeyWord.newyear.description)", value: "neujahr"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.rosemonday, key: "keywords.\(KeyWord.rosemonday.description)", value: KeyWord.rosemonday.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.rosemonday, key: "keywords.\(KeyWord.rosemonday.description)", value: "rosemonday"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.rosemonday, key: "keywords.\(KeyWord.rosemonday.description)", value: "rosenmontag"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.goodfriday, key: "keywords.\(KeyWord.goodfriday.description)", value: KeyWord.goodfriday.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.goodfriday, key: "keywords.\(KeyWord.goodfriday.description)", value: "goodfriday"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.goodfriday, key: "keywords.\(KeyWord.goodfriday.description)", value: "karfreitag"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.eastersunday, key: "keywords.\(KeyWord.eastersunday.description)", value: KeyWord.eastersunday.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.eastersunday, key: "keywords.\(KeyWord.eastersunday.description)", value: "eastersunday"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.eastersunday, key: "keywords.\(KeyWord.eastersunday.description)", value: "ostersonntag"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.eastermonday, key: "keywords.\(KeyWord.eastermonday.description)", value: KeyWord.eastermonday.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.eastermonday, key: "keywords.\(KeyWord.eastermonday.description)", value: "eastermonday"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.eastermonday, key: "keywords.\(KeyWord.eastermonday.description)", value: "ostermontag"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.labourday, key: "keywords.\(KeyWord.labourday.description)", value: KeyWord.labourday.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.labourday, key: "keywords.\(KeyWord.labourday.description)", value: "labourday"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.labourday, key: "keywords.\(KeyWord.labourday.description)", value: "tag_der_arbeit"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.whitsunday, key: "keywords.\(KeyWord.whitsunday.description)", value: KeyWord.whitsunday.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.whitsunday, key: "keywords.\(KeyWord.whitsunday.description)", value: "whitsunday"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.whitsunday, key: "keywords.\(KeyWord.whitsunday.description)", value: "pfingstsonntag"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.whitmonday, key: "keywords.\(KeyWord.whitmonday.description)", value: KeyWord.whitmonday.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.whitmonday, key: "keywords.\(KeyWord.whitmonday.description)", value: "whitmonday"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.whitmonday, key: "keywords.\(KeyWord.whitmonday.description)", value: "pfingstmontag"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.corpuschristi, key: "keywords.\(KeyWord.corpuschristi.description)", value: KeyWord.corpuschristi.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.corpuschristi, key: "keywords.\(KeyWord.corpuschristi.description)", value: "corpuschristi"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.corpuschristi, key: "keywords.\(KeyWord.corpuschristi.description)", value: "fronleichnam"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.halloween, key: "keywords.\(KeyWord.halloween.description)", value: KeyWord.halloween.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.halloween, key: "keywords.\(KeyWord.halloween.description)", value: "halloween"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.halloween, key: "keywords.\(KeyWord.halloween.description)", value: "reformationstag"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.allsaints, key: "keywords.\(KeyWord.allsaints.description)", value: KeyWord.allsaints.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.allsaints, key: "keywords.\(KeyWord.allsaints.description)", value: "allsaints"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.allsaints, key: "keywords.\(KeyWord.allsaints.description)", value: "allerheiligen"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.christmaseve, key: "keywords.\(KeyWord.christmaseve.description)", value: KeyWord.christmaseve.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.christmaseve, key: "keywords.\(KeyWord.christmaseve.description)", value: "christmaseve"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.christmaseve, key: "keywords.\(KeyWord.christmaseve.description)", value: "heiligabend"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.christmas, key: "keywords.\(KeyWord.christmas.description)", value: KeyWord.christmas.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.christmas, key: "keywords.\(KeyWord.christmas.description)", value: "christmas"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.christmas, key: "keywords.\(KeyWord.christmas.description)", value: "weihnachten"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.christmas2, key: "keywords.\(KeyWord.christmas2.description)", value: KeyWord.christmas2.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.christmas2, key: "keywords.\(KeyWord.christmas2.description)", value: "christmas2"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.christmas2, key: "keywords.\(KeyWord.christmas2.description)", value: "2.weihnachten"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.newyearseve, key: "keywords.\(KeyWord.newyearseve.description)", value: KeyWord.newyearseve.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.newyearseve, key: "keywords.\(KeyWord.newyearseve.description)", value: "newyearseve"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.newyearseve, key: "keywords.\(KeyWord.newyearseve.description)", value: "sylvester"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.one, key: "keywords.\(KeyWord.one.description)", value: KeyWord.one.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.one, key: "keywords.\(KeyWord.one.description)", value: "one"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.one, key: "keywords.\(KeyWord.one.description)", value: "eins"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.first, key: "keywords.\(KeyWord.first.description)", value: KeyWord.first.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.first, key: "keywords.\(KeyWord.first.description)", value: "first"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.first, key: "keywords.\(KeyWord.first.description)", value: "erste(.,n,r)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.two, key: "keywords.\(KeyWord.two.description)", value: KeyWord.two.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.two, key: "keywords.\(KeyWord.two.description)", value: "two"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.two, key: "keywords.\(KeyWord.two.description)", value: "zwei"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.second, key: "keywords.\(KeyWord.second.description)", value: KeyWord.second.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.second, key: "keywords.\(KeyWord.second.description)", value: "second"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.second, key: "keywords.\(KeyWord.second.description)", value: "zweite(.,n,r)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.three, key: "keywords.\(KeyWord.three.description)", value: KeyWord.three.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.three, key: "keywords.\(KeyWord.three.description)", value: "three"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.three, key: "keywords.\(KeyWord.three.description)", value: "drei"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.third, key: "keywords.\(KeyWord.third.description)", value: KeyWord.third.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.third, key: "keywords.\(KeyWord.third.description)", value: "third"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.third, key: "keywords.\(KeyWord.third.description)", value: "dritte(.,n,r)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.four, key: "keywords.\(KeyWord.four.description)", value: KeyWord.four.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.four, key: "keywords.\(KeyWord.four.description)", value: "four"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.four, key: "keywords.\(KeyWord.four.description)", value: "vier"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.fourth, key: "keywords.\(KeyWord.fourth.description)", value: KeyWord.fourth.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.fourth, key: "keywords.\(KeyWord.fourth.description)", value: "fourth"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.fourth, key: "keywords.\(KeyWord.fourth.description)", value: "vierte(.,n,r)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.five, key: "keywords.\(KeyWord.five.description)", value: KeyWord.five.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.five, key: "keywords.\(KeyWord.five.description)", value: "five"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.five, key: "keywords.\(KeyWord.five.description)", value: "fünf"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.fifth, key: "keywords.\(KeyWord.fifth.description)", value: KeyWord.fifth.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.fifth, key: "keywords.\(KeyWord.fifth.description)", value: "fifth"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.fifth, key: "keywords.\(KeyWord.fifth.description)", value: "fünfte(.,n,r)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.six, key: "keywords.\(KeyWord.six.description)", value: KeyWord.six.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.six, key: "keywords.\(KeyWord.six.description)", value: "six"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.six, key: "keywords.\(KeyWord.six.description)", value: "sechs"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.sixth, key: "keywords.\(KeyWord.sixth.description)", value: KeyWord.sixth.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.sixth, key: "keywords.\(KeyWord.sixth.description)", value: "sixth"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.sixth, key: "keywords.\(KeyWord.sixth.description)", value: "sechste(.,n,r)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.seven, key: "keywords.\(KeyWord.seven.description)", value: KeyWord.seven.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.seven, key: "keywords.\(KeyWord.seven.description)", value: "seven"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.seven, key: "keywords.\(KeyWord.seven.description)", value: "sieben"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.seventh, key: "keywords.\(KeyWord.seventh.description)", value: KeyWord.seventh.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.seventh, key: "keywords.\(KeyWord.seventh.description)", value: "seventh"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.seventh, key: "keywords.\(KeyWord.seventh.description)", value: "siebte(.,n,r)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.eight, key: "keywords.\(KeyWord.eight.description)", value: KeyWord.eight.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.eight, key: "keywords.\(KeyWord.eight.description)", value: "eight"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.eight, key: "keywords.\(KeyWord.eight.description)", value: "acht"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.eighth, key: "keywords.\(KeyWord.eighth.description)", value: KeyWord.eighth.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.eighth, key: "keywords.\(KeyWord.eighth.description)", value: "eighth"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.eighth, key: "keywords.\(KeyWord.eighth.description)", value: "achte(.,n,r)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.nine, key: "keywords.\(KeyWord.nine.description)", value: KeyWord.nine.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.nine, key: "keywords.\(KeyWord.nine.description)", value: "nine"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.nine, key: "keywords.\(KeyWord.nine.description)", value: "neun"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.ninth, key: "keywords.\(KeyWord.ninth.description)", value: KeyWord.ninth.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.ninth, key: "keywords.\(KeyWord.ninth.description)", value: "ninth"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.ninth, key: "keywords.\(KeyWord.ninth.description)", value: "neunte(.,n,r)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.ten, key: "keywords.\(KeyWord.ten.description)", value: KeyWord.ten.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.ten, key: "keywords.\(KeyWord.ten.description)", value: "ten"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.ten, key: "keywords.\(KeyWord.ten.description)", value: "zehn"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.tenth, key: "keywords.\(KeyWord.tenth.description)", value: KeyWord.tenth.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.tenth, key: "keywords.\(KeyWord.tenth.description)", value: "tenth"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.tenth, key: "keywords.\(KeyWord.tenth.description)", value: "zehnte(.,n,r)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.eleven, key: "keywords.\(KeyWord.eleven.description)", value: KeyWord.eleven.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.eleven, key: "keywords.\(KeyWord.eleven.description)", value: "eleven"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.eleven, key: "keywords.\(KeyWord.eleven.description)", value: "elf"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.next, key: "keywords.\(KeyWord.next.description)", value: KeyWord.next.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.next, key: "keywords.\(KeyWord.next.description)", value: "next"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.next, key: "keywords.\(KeyWord.next.description)", value: "nächste(.,n,r,s)"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.twelve, key: "keywords.\(KeyWord.twelve.description)", value: KeyWord.twelve.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.twelve, key: "keywords.\(KeyWord.twelve.description)", value: "twelve"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.twelve, key: "keywords.\(KeyWord.twelve.description)", value: "zwölf"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.thirteen, key: "keywords.\(KeyWord.thirteen.description)", value: KeyWord.thirteen.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.thirteen, key: "keywords.\(KeyWord.thirteen.description)", value: "thirteen"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.thirteen, key: "keywords.\(KeyWord.thirteen.description)", value: "dreizehn"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.ascensionday, key: "keywords.\(KeyWord.ascensionday.description)", value: KeyWord.ascensionday.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.ascensionday, key: "keywords.\(KeyWord.ascensionday.description)", value: "ascensionday"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.ascensionday, key: "keywords.\(KeyWord.ascensionday.description)", value: "christihimmelfahrt"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.fourteen, key: "keywords.\(KeyWord.fourteen.description)", value: KeyWord.fourteen.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.fourteen, key: "keywords.\(KeyWord.fourteen.description)", value: "fourteen"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.fourteen, key: "keywords.\(KeyWord.fourteen.description)", value: "vierzehn"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.inKey, key: "keywords.\(KeyWord.inKey.description)", value: KeyWord.inKey.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.inKey, key: "keywords.\(KeyWord.inKey.description)", value: "in"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.inKey, key: "keywords.\(KeyWord.inKey.description)", value: "in"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.and, key: "keywords.\(KeyWord.and.description)", value: KeyWord.and.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.and, key: "keywords.\(KeyWord.and.description)", value: "and"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.and, key: "keywords.\(KeyWord.and.description)", value: "und"),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "raw", enumKey: KeyWord.comma, key: "keywords.\(KeyWord.comma.description)", value: KeyWord.comma.description),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "en", enumKey: KeyWord.comma, key: "keywords.\(KeyWord.comma.description)", value: ","),
        LocalizationModel(id: UUID(), languageModel: .languages, languageCode: "de", enumKey: KeyWord.comma, key: "keywords.\(KeyWord.comma.description)", value: ",")
    ]
    private static func loadLocalizations(atPath path: String) throws -> [String: Any] {
        let fileContent = try Data(contentsOf: URL(fileURLWithPath: path))
        let jsonObject = try JSONSerialization.jsonObject(with: fileContent, options: [])
        guard let localizations = jsonObject as? [String: Any] else { throw LocalizationControllerError.parsingFailure(message: "Invalid localization file format at path: \(path). Expected string indexed dictionary at the root level.") }
        return localizations
    }
}
