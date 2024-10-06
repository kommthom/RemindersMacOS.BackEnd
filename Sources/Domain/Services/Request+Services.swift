//
//  Request+Services.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor

public extension Request {
    var countries: CountryRepositoryProtocol { application.repositories.countries.for(self) }
    var locations: LocationRepositoryProtocol { application.repositories.locations.for(self) }
    var locales: LocaleRepositoryProtocol { application.repositories.locales.for(self) }
    var languages: LanguageRepositoryProtocol { application.repositories.languages.for(self) }
    var users: UserRepositoryProtocol { application.repositories.users.for(self) }
    var refreshTokens: RefreshTokenRepositoryProtocol { application.repositories.refreshTokens.for(self) }
    var emailTokens: EmailTokenRepositoryProtocol { application.repositories.emailTokens.for(self) }
    var passwordTokens: PasswordTokenRepositoryProtocol { application.repositories.passwordTokens.for(self) }
    var projects: ProjectRepositoryProtocol { application.repositories.projects.for(self) }
    var tasks: TaskRepositoryProtocol { application.repositories.tasks.for(self) }
    var settings: UserSettingRepositoryProtocol { application.repositories.settings.for(self) }
    var tags: TagRepositoryProtocol { application.repositories.tags.for(self) }
    var rules: RuleRepositoryProtocol { application.repositories.rules.for(self) }
    var attachments: AttachmentRepositoryProtocol { application.repositories.attachments.for(self) }
    var uploads: UploadRepositoryProtocol { application.repositories.uploads.for(self) }
    var histories: HistoryRepositoryProtocol { application.repositories.histories.for(self) }
    var repetitions: RepetitionRepositoryProtocol { application.repositories.repetitions.for(self) }
    var timePeriods: TimePeriodRepositoryProtocol { application.repositories.timePeriods.for(self) }
    var localizations: LocalizationRepositoryProtocol { application.repositories.localizations.for(self) }
    var userLocalization: UserLocalizationProtocol { application.localizations.userLocalization.for(self) }
}
