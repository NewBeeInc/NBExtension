//
//  keyOfVv+NSDate.swift
//  Aura
//
//  Created by keyOfVv on 10/8/15.
//  Copyright © 2015 com.sangebaba. All rights reserved.
//

import Foundation

public let SECOND_PER_MINUTE = 60
public let SECOND_PER_HOUR   = 3600
public let SECOND_PER_DAY    = 86400
public let MINUTE_PER_HOUR   = 60
public let MINUTE_PER_DAY    = 1440
public let HOUR_PER_DAY      = 24

// MARK: - NSDate扩展, 快速访问NSDate对象的年/月/日/时/分/秒读数

public extension NSDate {

	/// 秒针读数(字符串)
	public var second: String {
		get {
			let formatter = NSDateFormatter()
			formatter.dateFormat = "ss"
			return formatter.stringFromDate(self)
		}
	}

	/// 秒针读数(整型)
	public var secondValue: Int {
		return Int(self.second)!
	}

	/// 分针读数(字符串)
	public var minute: String {
		get {
			let formatter = NSDateFormatter()
			formatter.dateFormat = "mm"
			return formatter.stringFromDate(self)
		}
	}

	/// 分针读数(整型)
	public var minuteValue: Int {
		return Int(self.minute)!
	}

	/// 12小时制时针读数(字符串)
	public var hour12: String {
		get {
			let formatter = NSDateFormatter()
			formatter.dateFormat = "hh"
			return formatter.stringFromDate(self)
		}
	}

	/// 12小时制时针读数整型(整型)
	public var hour12Value: Int {
		return Int(self.hour12)!
	}

	/// 24小时制时针读数(字符串)
	public var hour24: String {
		get {
			let formatter = NSDateFormatter()
			formatter.dateFormat = "HH"
			return formatter.stringFromDate(self)
		}
	}

	/// 24小时制时针读数(整型)
	public var hour24Value: Int {
		return Int(self.hour24)!
	}

	/// 日(字符串)
	public var day: String {
		get {
			let formatter = NSDateFormatter()
			formatter.dateFormat = "dd"
			return formatter.stringFromDate(self)
		}
	}

	/// 日(整型)
	public var dayValue: Int {
		return Int(self.day)!
	}

	/// 月(字符串)
	public var month: String {
		get {
			let formatter = NSDateFormatter()
			formatter.dateFormat = "MM"
			return formatter.stringFromDate(self)
		}
	}

	/// 月(整型)
	public var monthValue: Int {
		return Int(self.month)!
	}

	/// 年(字符串)
	public var year: String {
		get {
			let formatter = NSDateFormatter()
			formatter.dateFormat = "yyyy"
			return formatter.stringFromDate(self)
		}
	}

	/// 年(整型)
	public var yearValue: Int {
		return Int(self.year)!
	}
}

// MARK: - NSDate扩展, 时间差计算

public extension NSDate {

	/// 指定的NSDate对象距离现在的分钟数
	public var timeIntervalFromNowInMinute: Int {
		get {
			return Int(abs(self.timeIntervalSinceNow) / 60.0)
		}
	}

	/// 指定的NSDate对象距离现在的小时数
	public var timeIntervalFromNowInHour: Int {
		get {
			return Int(abs(self.timeIntervalSinceNow) / 3600.0)
		}
	}

	/// 指定的NSDate对象距离现在的天数
	public var timeIntervalFromNowInDay: Int {
		get {
			let dayIntervalInDouble = abs(self.timeIntervalSinceNow) / 86400.0
			let dayIntervalInInt = Int(abs(self.timeIntervalSinceNow) / 86400.0)
			if Double(dayIntervalInInt) < dayIntervalInDouble {
				return dayIntervalInInt + 1
			}
			return Int(abs(self.timeIntervalSinceNow) / 86400.0)
		}
	}
}

// MARK: - NSDate扩展, 时间判断

public extension NSDate {

	/// 未来?
	public var isFuture: Bool {
		return self.timeIntervalSinceNow > 0
	}

	/// 过去?
	public var isPast: Bool {
		return self.timeIntervalSinceNow < 0
	}

	/// 现在?
	public var isNow: Bool {
		return self.timeIntervalSinceNow == 0
	}

	/// 刚刚?
	public var isJustNow: Bool {
		if self.isFuture {
			return false
		}
		return abs(self.timeIntervalSinceNow) < 60
	}

	/// 今天?
	public var isToday: Bool {
		let formatter = NSDateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		let dateString = formatter.stringFromDate(self)
		let todayString = formatter.stringFromDate(NSDate())

		return dateString == todayString
	}

	/// 昨天?
	public var isYesterday: Bool {
		if self.isFuture {
			return false
		}
		if !self.isToday && self.timeIntervalFromNowInMinute < ((self.hour24Value + HOUR_PER_DAY) * MINUTE_PER_HOUR + self.minuteValue) {
			return true
		}
		return false
	}

	/// 前天?
	public var isTheDayBeforeYesterday: Bool {
		if self.isFuture {
			return false
		}
		if !self.isToday && !self.isYesterday && self.timeIntervalFromNowInMinute < (self.hour24Value + HOUR_PER_DAY * 2) * MINUTE_PER_HOUR + self.minuteValue {
			return true
		}
		return false
	}

	/// 本月?
	public var isThisMonth: Bool {
		let formatter = NSDateFormatter()
		formatter.dateFormat = "yyyy-MM"
		let dateString = formatter.stringFromDate(self)
		let todayString = formatter.stringFromDate(NSDate())

		return dateString == todayString
	}

	/// 今年?
	public var isThisYear: Bool {
		let formatter = NSDateFormatter()
		formatter.dateFormat = "yyyy"
		let dateString = formatter.stringFromDate(self)
		let todayString = formatter.stringFromDate(NSDate())

		return dateString == todayString
	}
}

