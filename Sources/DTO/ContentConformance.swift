//
//  ContentConformance.swift
//  RemindersMacOS.BackEnd
//
//  Created by Thomas Benninghaus on 28.09.24.
//

import RemindersMacOS.DTOs
import UserDTOs
import Vapor

extension AccessTokenRequest: Content {}
extension AccessTokenResponse: Content {}
extension AttachmentsDTO: Content {}
extension AttachmentsDTO: Content {}
extension CountriesDTO: Content {}
extension CountryDTO: Content {}
extension HistoriesDTO: Content {}
extension HistoryDTO: Content {}
extension LanguageDTO: Content {}
extension LanguagesDTO: Content {}
extension LocaleDTO: Content {}
extension LocalesDTO: Content {}
extension LocalizationDTO: Content {}
extension LocalizationsDTO: Content {}
extension LocationDTO: Content {}
extension LocationsDTO: Content {}
extension LoginRequest: Content {}
extension LoginResponse: Content {}
extension ProjectDTO: Content {}
extension ProjectsDTO: Content {}
extension RecoverAccountRequest: Content {}
extension RepetitionDTO: Content {}
extension RepetitionsDTO: Content {}
extension ResetPasswordRequest: Content {}
extension RuleDTO: Content {}
extension RulesDTO: Content {}
extension RuleSelectionDTO: Content {}
extension RuleSelectionsDTO: Content {}
extension SendEmailVerificationRequest: Content {}
extension GetSettingsRequest: Content {}
extension SettingDTO: Content {}
extension SettingsDTO: Content {}
extension TagDTO: Content {}
extension TagsDTO: Content {}
extension TagSelectionDTO: Content {}
extension TagSelectionsDTO: Content {}
extension TaskDTO: Content {}
extension TaskGroupDTO: Content {}
extension TaskGroupsDTO: Content {}
extension TasksDTO: Content {}
extension TimePeriodDTO: Content {}
extension TimePeriodsDTO: Content {}
extension TimePeriodSelectionDTO: Content {}
extension TimePeriodSelectionsDTO: Content {}
extension UploadDTO: Content {}
extension UploadsDTO: Content {}
extension UserDTO: Content {}
extension UsersDTO: Content {}
extension UUIDArrayRequest: Content {}
extension UUIDRequest: Content {}

extension Payload: Authenticatable {}

extension AttachmentDTO: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("comment", as: String.self, is: .count(5...))
	}
}

extension LocalizationDTO: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("languageModel", as: ModelType.self, is: .in(ModelTypes().localizationModels))
		validations.add("languageCode", as: String.self, is: .count(2...))
		validations.add("key", as: String?.self, is: .nil || .count(5...))
		validations.add("enumKey", as: KeyWord.RawValue?.self, is: .nil || .in(KeyWord.AllCases().map { $0.rawValue } ))
		validations.add("value", as: String?.self, is: .nil || .count(5...))
	}
}

extension LoginRequest: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("email", as: String.self, is: .email)
		validations.add("password", as: String.self, is: !.empty)
	}
}

extension Payload: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("fullName", as: String.self, is: .count(3...))
		validations.add("email", as: String.self, is: .email)
	}
}

extension ProjectDTO: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("name", as: String.self, is: .count(5...))
		validations.add("level", as: Int.self, is: .range(1...))
		validations.add("path", as: String.self, is: .count(1...))
	}
}

extension RecoverAccountRequest: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("password", as: String.self, is: .count(8...))
		validations.add("confirmPassword", as: String.self, is: !.empty)
		validations.add("token", as: String.self, is: !.empty)
	}
}

extension RepetitionDTO: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("repetitionText", as: String.self, is: .count(5...))
	}
}

extension ResetPasswordRequest: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("email", as: String.self, is: .email)
	}
}

extension RuleDTO: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("description", as: String.self, is: .count(5...))
	}
}

extension RuleSelectionsDTO: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("taskId", as: UUID.self, is: .valid)
	}
}

extension GetSettingsRequest: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("scope", as: ScopeType.self, is: .in(.sidebarOptionsType, .sidebarType))
	}
}

extension SettingDTO: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("name", as: String.self, is: .count(5...))
		validations.add("description", as: String.self, is: .count(8...))
	}
}

extension TagDTO: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("description", as: String.self, is: .count(5...))
	}
}

extension TagSelectionsDTO: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("taskId", as: UUID.self, is: .valid)
	}
}

extension TaskDTO: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("itemDescription", as: String.self, is: .count(3...))
		validations.add("title", as: String.self, is: .count(3...))
	}
}

extension TimePeriodDTO: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("fromTime", as: Date?.self, is: !.nil)
		validations.add("toTime", as: Date?.self, is: !.nil)
	}
}

extension TimePeriodSelectionsDTO: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("taskId", as: UUID.self, is: .valid)
	}
}

extension UploadDTO: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("fileName", as: String.self, is: .count(4...))
	}
}

extension UploadsDTO: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("uploads", as: [UploadDTO].self, is: .count(1...))
	}
}

extension UserDTO: Validatable {
	public static func validations(_ validations: inout Validations) {
		validations.add("fullName", as: String.self, is: .count(3...))
		validations.add("email", as: String.self, is: .email)
		validations.add("password", as: String.self, is: .count(8...))
	}
}
