//
//  DoubleExtension.swift
//  Aura
//
//  Created by keyOfVv on 1/8/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Double与其他基本类型的便捷转换
public extension Double {
	/// 转换为CGFloat
	public var cgFloat: CGFloat { return CGFloat(self) }
	/// 转换为Float
	public var float: Float { return Float(self) }
	/// 转换为Int
	public var int: Int { return Int(self) }

	/// 四舍五入保留小数点后1位
	@available(*, deprecated, message: "user -roundTo(_:) instead")
	var roundTo1: Double {
		let converter = NumberFormatter()
		let formatter = NumberFormatter()
		formatter.numberStyle = NumberFormatter.Style.none
		formatter.minimumFractionDigits = 1
		formatter.roundingMode = .down
		formatter.maximumFractionDigits = 1
		if let stringFromDouble =  formatter.string(from: NSNumber(value: self)) {
			if let doubleFromString = converter.number( from: stringFromDouble ) as? Double {
				return doubleFromString
			}
		}
		return 0
	}

	/**
	四舍五入保留小数点后1位
	NSNumberFormatterRoundingMode:
	- case RoundCeiling		:	Round towards positive infinity. 零舍一入
	- case RoundFloor		:	Round towards negative infinity. 九舍零入
	- case RoundDown		:	Round towards zero. 九舍零入
	- case RoundUp			:	Round away from zero. 零舍一入
	- case RoundHalfEven	:	Round towards the nearest integer, or towards an even number if equidistant. 四舍五入?
	- case RoundHalfDown	:	Round towards the nearest integer, or towards zero if equidistant. 五舍六入?
	- case RoundHalfUp		:	Round towards the nearest integer, or away from zero if equidistant. 四舍五入!

	- parameter to: 小数点后的位数

	- returns: 四舍五入后的数值
	*/
	public func roundTo(_ to: Int) -> Double {
		let converter = NumberFormatter()
		let formatter = NumberFormatter()
        formatter.numberStyle           = NumberFormatter.Style.none
        formatter.minimumFractionDigits = to
        formatter.roundingMode          = .down
        formatter.maximumFractionDigits = to
		if let stringFromDouble =  formatter.string(from: NSNumber(value: self)) {
			if let doubleFromString = converter.number(from: stringFromDouble) as? Double {
				return doubleFromString
			}
		}
		return 0.0
	}
}
