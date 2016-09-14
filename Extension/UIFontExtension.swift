//
//  UIFontExtension.swift
//  alpha
//
//  Created by keyOfVv on 1/11/16.
//  Copyright © 2016 com.keyofvv. All rights reserved.
//

import UIKit

// MARK: - UIFont扩展

public extension UIFont {

	/**
	字体名称枚举

	- Noteworthy:         Noteworthy字体
	- NoteworthyBold:     Noteworthy-Bold字体
	- HelveticaNeueLight: HelveticaNeue-Light字体
	- HelveticaNeueThin:  HelveticaNeue-Thin字体
	*/
	public enum Name: String {
		case Noteworthy = "Noteworthy"
		case NoteworthyBold = "Noteworthy-Bold"

		case HelveticaNeue = "HelveticaNeue"
		case HelveticaNeueBold = "HelveticaNeue-Bold"
		case HelveticaNeueMedium = "HelveticaNeue-Medium"
		case HelveticaNeueLight = "HelveticaNeue-Light"
		case HelveticaNeueThin = "HelveticaNeue-Thin"
		case HelveticaNeueUltraLight = "HelveticaNeue-UltraLight"
	}

	/**
	快速构造方法

	- parameter fontName: 字体名称
	- parameter size:     字体大小

	- returns: UIFont对象
	*/
	public convenience init?(fontName: Name, size: Double) {
		self.init(name: fontName.rawValue, size: size.cgFloat)
	}

	/**
	创建指定大小的Noteworthy字体对象

	- parameter size: 字体大小

	- returns: 返回一个指定大小的Noteworthy字体对象
	*/
	public class func noteworthy(_ size: Double) -> UIFont {
		return UIFont(fontName: Name.Noteworthy, size: size)!
	}

	/**
	创建指定大小的Noteworthy-Bold字体对象

	- parameter size: 字体大小

	- returns: 返回一个指定大小的Noteworthy-Bold字体对象
	*/
	public class func noteworthyBold(_ size: Double) -> UIFont {
		return UIFont(fontName: Name.NoteworthyBold, size: size)!
	}

	/**
	创建指定大小的HelveticaNeue-Light字体对象

	- parameter size: 字体大小

	- returns: 返回一个指定大小的HelveticaNeue-Light字体对象
	*/
	public class func helveticaNeueLight(_ size: Double) -> UIFont {
		return UIFont(fontName: Name.HelveticaNeueLight, size: size)!
	}

	/**
	创建指定大小的HelveticaNeue-Thin字体对象

	- parameter size: 字体大小

	- returns: 返回一个指定大小的HelveticaNeue-Thin字体对象
	*/
	public class func helveticaNeueThin(_ size: Double) -> UIFont {
		return UIFont(fontName: Name.HelveticaNeueThin, size: size)!
	}

	public class func helveticaNeue(_ size: Double) -> UIFont {
		return UIFont(fontName: Name.HelveticaNeue, size: size)!
	}

}
