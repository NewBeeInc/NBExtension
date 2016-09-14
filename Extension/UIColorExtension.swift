//
//  UIColorExtension.swift
//  Aura
//
//  Created by keyOfVv on 1/8/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIColor快速构造方法/HEX格式颜色转化方法

public extension UIColor {

	/**
	由RGB值快速构造UIColor对象

	- parameter R: R值
	- parameter G: G值
	- parameter B: B值

	- returns: UIColor对象
	*/
	public convenience init(R: Double, G: Double, B: Double) {
		let red:   CGFloat = CGFloat(R/255.0)
		let green: CGFloat = CGFloat(G/255.0)
		let blue:  CGFloat = CGFloat(B/255.0)
		let alpha: CGFloat = CGFloat(1.0)
		self.init(red: red, green: green, blue: blue, alpha:alpha)
	}

	/**
	根据HEX格式生成UIColor对象

	- parameter rgba: HEX格式色值字符串

	- returns: UIColor对象
	*/
	@available(*, unavailable, message: "此函数的实现尚未完善, 勿用")
	public convenience init(rgba: String) {
		var red:   CGFloat = 0.0
		var green: CGFloat = 0.0
		var blue:  CGFloat = 0.0
		var alpha: CGFloat = 1.0

		if rgba.hasPrefix("#") {
			let index   = rgba.characters.index(rgba.startIndex, offsetBy: 1)
			let hex     = rgba.substring(from: index)
			let scanner = Scanner(string: hex)
			var hexValue: CUnsignedLongLong = 0
			if scanner.scanHexInt64(&hexValue) {
				switch (hex.characters.count) {
				case 3:
					red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
					green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
					blue  = CGFloat(hexValue & 0x00F)              / 15.0
				case 4:
					red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
					green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
					blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
					alpha = CGFloat(hexValue & 0x000F)             / 15.0
				case 6:
					red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
					green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
					blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
				case 8:
					red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
					green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
					blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
					alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
				default:
					print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
				}
			} else {
				print("Scan hex error")
			}
		} else {
			print("Invalid RGB string, missing '#' as prefix", terminator: "")
		}
		self.init(red:red, green:green, blue:blue, alpha:alpha)
	}

	/**
	生成随机颜色

	- returns: UIColor对象
	*/
	public class func randomColor() -> UIColor {
		let red	  = CGFloat(arc4random_uniform(256)) / 255.0
		let green = CGFloat(arc4random_uniform(256)) / 255.0
		let blue  = CGFloat(arc4random_uniform(256)) / 255.0
		return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
	}

	/**
	生成特定灰度的灰色

	- parameter value: 灰度, 介于0.0~255.0之间

	- returns: UIColor对象
	*/
	public class func grayColorWith(_ value: CGFloat) -> UIColor {
		let red	  = value / 255.0
		let green = red, blue = red
		return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
	}

	/**
	生成超淡的灰色, 灰度为0.75

	- returns: UIColor对象
	*/
	public class func ultraLightGrayColor() -> UIColor {
		let red	  = CGFloat(0.75)
		let green = red, blue = red
		return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
	}
}
