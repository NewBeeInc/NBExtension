//
//  NSLocaleExtension.swift
//  Aura
//
//  Created by Ke Yang on 7/4/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import Foundation

enum Language {
	case Unknown, Chinese, English, Korean
}

enum Country {
	case Unknown, China
}

// MARK: -
extension NSLocale {

	class func getCurrentLanguage() -> Language {
		guard let langCode = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as? String
			else { return Language.Unknown }
		switch langCode {
		case "zh":
			return Language.Chinese
		case "en":
			return Language.English
		case "ko":
			return Language.Korean
		default:
			return Language.Unknown
		}
	}

	class func getCountryCode() -> Country {
		guard let countryCode = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String
			else { return Country.Unknown }
		switch countryCode {
		case "CN":
			return Country.China
		default:
			return Country.Unknown
		}
	}
}