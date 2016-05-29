//
//  keyOfVv+UIImage.swift
//  Aura
//
//  Created by keyOfVv on 12/23/15.
//  Copyright © 2015 com.sangebaba. All rights reserved.
//

import UIKit

// MARK: - UIImage扩展, 图片裁剪方法

public extension UIImage {

	/// UIImage宽度
	public var width: CGFloat {
		return self.size.width
	}

	/// UIImage高度
	public var height: CGFloat {
		return self.size.height
	}

	/**
	将图片裁剪成一个圆形图片, 配上指定宽度/颜色的圆形边框

	- parameter original:    原图
	- parameter borderColor: 边框颜色
	- parameter borderWidth: 边框宽度

	- returns: 裁剪后的新UIImage对象
	*/
	public class func circularImageWith(original: UIImage?, borderColor: UIColor?, borderWidth: CGFloat) -> UIImage? {
		if let image = original {
			let contextWidth  = image.width  + borderWidth * CGFloat(2.0)
			let contextHeight = image.height + borderWidth * CGFloat(2.0)
			let contextSize   = CGSizeMake(contextWidth, contextHeight)

			let outerRect = CGRectMake(0.0, 0.0, contextWidth, contextHeight)
			let innerRect = CGRectMake(borderWidth, borderWidth, image.width, image.height)

			UIGraphicsBeginImageContextWithOptions(contextSize, false, 0.0)
			let context = UIGraphicsGetCurrentContext()

			if let color = borderColor {
				CGContextAddEllipseInRect(context, outerRect)
				color.set()
				CGContextFillPath(context)
			}

			CGContextAddEllipseInRect(context, innerRect)
			CGContextClip(context)

			image.drawInRect(innerRect)

			let newImage = UIGraphicsGetImageFromCurrentImageContext()

			UIGraphicsEndImageContext()

			return newImage

		} else {
			return nil
		}
	}

	/**
	将图片裁剪成一个圆形图片, 配上指定宽度/颜色的圆形边框

	- parameter name:        原图的名称
	- parameter borderColor: 边框颜色
	- parameter borderWidth: 边框宽度

	- returns: 裁剪后的新UIImage对象
	*/
	public class func circularImage(named name: String, borderColor: UIColor?, borderWidth: CGFloat) -> UIImage? {
		let original = UIImage(named: name)
		return UIImage.circularImageWith(original, borderColor: borderColor, borderWidth: borderWidth)
	}

	/**
	将图片裁剪成一个圆形图片

	- parameter original: 原图

	- returns: 裁剪后的新UIImage对象
	*/
	public class func circularImageWith(original: UIImage?) -> UIImage? {
		return UIImage.circularImageWith(original, borderColor: nil, borderWidth: 0.0)
	}

	/**
	将图片裁剪成一个圆形图片

	- parameter name: 原图的名称

	- returns: 裁剪后的新UIImage对象
	*/
	public class func circularImage(named name: String) -> UIImage? {
		return UIImage.circularImage(named: name, borderColor: nil, borderWidth: 0.0)
	}

	/**
	将图片裁剪成一个指定尺寸的圆形图片, 配上指定宽度/颜色的圆形边框

	- parameter original:    原图
	- parameter size:        目标图片的尺寸
	- parameter borderColor: 边框颜色
	- parameter borderWidth: 边框宽度

	- returns: 裁剪后的新UIImage对象
	*/
	public class func circularImage(original: UIImage?, size: CGSize, borderColor: UIColor?, borderWidth: CGFloat) -> UIImage? {
		if let image = original {
			let contextWidth  = size.width
			let contextHeight = size.height
			let contextSize   = CGSizeMake(contextWidth, contextHeight)

			let outerRect = CGRectMake(0.0, 0.0, contextWidth, contextHeight)
			let innerRect = CGRectMake(borderWidth, borderWidth, contextWidth - borderWidth * 2.0, contextHeight - borderWidth * 2.0)

			UIGraphicsBeginImageContextWithOptions(contextSize, false, 0.0)
			let context = UIGraphicsGetCurrentContext()

			if let color = borderColor {
				CGContextAddEllipseInRect(context, outerRect)
				color.set()
				CGContextFillPath(context)
			}

			CGContextAddEllipseInRect(context, innerRect)
			CGContextClip(context)

			image.drawInRect(innerRect)

			let newImage = UIGraphicsGetImageFromCurrentImageContext()

			UIGraphicsEndImageContext()

			return newImage

		} else {
			return nil
		}
	}

	/**
	将图片裁剪成一个指定尺寸的圆形图片, 配上指定宽度/颜色的圆形边框

	- parameter name:        原图的名称
	- parameter size:        目标图片的尺寸
	- parameter borderColor: 边框颜色
	- parameter borderWidth: 边框宽度

	- returns: 裁剪后的新UIImage对象
	*/
	public class func circularImage(named name: String, size: CGSize, borderColor: UIColor?, borderWidth: CGFloat) -> UIImage? {
		let original = UIImage(named: name)
		return UIImage.circularImage(original, size: size, borderColor: borderColor, borderWidth: borderWidth)
	}

	/**
	将图片进行缩放

	- parameter scale: 缩放比例

	- returns: 缩放后的新图片
	*/
	public func imageScaledBy(scale: CGFloat) -> UIImage {
		let imageW = self.width
		let imageH = self.height
		let targetW = imageW * scale
		let targetH = imageH * scale
		let targetRect = CGRectMake(0.0, 0.0, targetW, targetH)

		UIGraphicsBeginImageContextWithOptions(targetRect.size, false, 0.0)
		self.drawInRect(targetRect)
		let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return scaledImage
	}
}