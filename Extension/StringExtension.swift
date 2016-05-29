//
//  keyOfVv+String.swift
//  Aura
//
//  Created by keyOfVv on 11/4/15.
//  Copyright © 2015 com.sangebaba. All rights reserved.
//

import Foundation

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
		return self[self.startIndex.advancedBy(i)]
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
	public func boundingRectWithSize(size: CGSize, attributes: Dictionary<String, AnyObject>?) -> CGRect {
		return (self as NSString).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
	}

	public func boundingRectWith(size: CGSize, font: UIFont?) -> CGRect {
		if font == nil { return CGRectZero }

		return (self as NSString).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font!], context: nil)
	}

	/**
	按索引范围获取字符串

	- parameter r: 索引范围

	- returns: 按索引范围截取的新字符串
	*/
	public subscript (r: Range<Int>) -> String {
		return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
	}

	/**
	字符串的MD5加密字符串

	- returns: 经过MD5加密后的字符串
	*/
	public func md5() -> String! {
		let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
		let strLen = CUnsignedInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
		let digestLen = Int(CC_MD5_DIGEST_LENGTH)
		let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
		CC_MD5(str!, strLen, result)
		let hash = NSMutableString()
		for i in 0 ..< digestLen {
			hash.appendFormat("%02x", result[i])
		}
		result.destroy()
		return String(format: hash as String)
	}

	public var bytesInfo: (UnsafePointer<UInt8>?, Int) {
		guard let data = (self as NSString).dataUsingEncoding(NSUTF8StringEncoding) else {
			return (nil, 0)
		}
		let bytes = data.bytes
		let length = data.length
		return (UnsafePointer<UInt8>(bytes), length)
	}

	/**
	邮件地址?

	- returns: 布尔值
	*/
	public func isEmail() -> Bool {
		let string = self as NSString
		let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
		let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
		let match = regex?.firstMatchInString(self, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, string.length))
		return (match != nil) ? true : false
	}

	/**
	手机号?

	- returns: 布尔值
	*/
	public func isMobile() -> Bool {
		let string = self as NSString
		let pattern = "^1[0-9]\\d{9}$"
		let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
		let match = regex?.firstMatchInString(self, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, string.length))
		return (match != nil) ? true : false
	}

	/**
	验证码?

	- returns: 布尔值
	*/
	public func isCaptcha() -> Bool {
		let string = self as NSString
		let pattern = "^[0-9]+$"
		let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
		let match = regex?.firstMatchInString(self, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, string.length))
		return (match != nil) ? true : false
	}
}