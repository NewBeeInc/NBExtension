//
//  keyOfVv+String.swift
//  Aura
//
//  Created by keyOfVv on 11/4/15.
//  Copyright © 2015 com.sangebaba. All rights reserved.
//

import UIKit

// MARK: - String扩展, 索引访问/MD5加密/正则判断

public extension String {

	/// String长度
	public var length: Int {
		get {
			return self.characters.count
		}
	}

	/**
	按索引获取单个字符

	- parameter i: 索引值

	- returns: 单个字符
	*/
	public subscript (i: Int) -> Character {
		return self[self.characters.index(self.startIndex, offsetBy: i)]
	}

	/**
	按索引获取单字符的字符串

	- parameter i: 索引值

	- returns: 单字符组成的字符串
	*/
	public subscript (i: Int) -> String {
		return String(self[i] as Character)
	}

	/**
	NSString的-boundingRectWithSize(_:options:attributes:context)方法的简化版

	- parameter size:       文本排版的限制尺寸
	- parameter attributes: 文本属性
	*/
	public func boundingRectWithSize(_ size: CGSize, attributes: Dictionary<String, AnyObject>?) -> CGRect {
		return (self as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
	}

	public func boundingRectWith(_ size: CGSize, font: UIFont?) -> CGRect {
		if font == nil { return CGRect.zero }

		return (self as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font!], context: nil)
	}

	/**
	按索引范围获取字符串

	- parameter r: 索引范围

	- returns: 按索引范围截取的新字符串
	*/
	public subscript (r: Range<Int>) -> String {
		return substring(with: (characters.index(startIndex, offsetBy: r.lowerBound) ..< characters.index(startIndex, offsetBy: r.upperBound)))
	}

	/**
	字符串的MD5加密字符串

	- returns: 经过MD5加密后的字符串
	*/
	public func md5() -> String! {
		let str = self.cString(using: String.Encoding.utf8)
		let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
		let digestLen = Int(CC_MD5_DIGEST_LENGTH)
		let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
		CC_MD5(str!, strLen, result)
		let hash = NSMutableString()
		for i in 0 ..< digestLen {
			hash.appendFormat("%02x", result[i])
		}
		result.deinitialize()
		return String(format: hash as String)
	}

	public var bytesInfo: (UnsafeRawPointer?, Int) {
		guard let data = (self as NSString).data(using: String.Encoding.utf8.rawValue) else {
			return (nil, 0)
		}
		let bytes = (data as NSData).bytes
		let length = data.count
		return (bytes, length)
	}

	/**
	邮件地址?

	- returns: 布尔值
	*/
	public func isEmail() -> Bool {
		let string = self as NSString
		let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
		let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
		let match = regex?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, string.length))
		return (match != nil) ? true : false
	}

	/**
	手机号?

	- returns: 布尔值
	*/
	public func isMobile() -> Bool {
		let string = self as NSString
		let pattern = "^1[0-9]\\d{9}$"
		let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
		let match = regex?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, string.length))
		return (match != nil) ? true : false
	}

	/**
	验证码?

	- returns: 布尔值
	*/
	public func isCaptcha() -> Bool {
		let string = self as NSString
		let pattern = "^[0-9]+$"
		let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
		let match = regex?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, string.length))
		return (match != nil) ? true : false
	}
}
