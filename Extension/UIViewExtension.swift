//
//  keyOfVv+UIView.swift
//  Aura
//
//  Created by keyOfVv on 11/4/15.
//  Copyright © 2015 com.sangebaba. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 快速访问UIView尺寸位置的各项属性

public extension UIView {

	/// 原点横坐标
	public var x: CGFloat {
		get { return self.frame.origin.x }
		set { self.frame.origin.x = newValue }
	}

	/// 原点纵坐标
	public var y: CGFloat {
		get { return self.frame.origin.y }
		set { self.frame.origin.y = newValue }
	}

	/// 宽度
	public var width: CGFloat {
		get { return self.frame.size.width }
		set { self.frame.size.width = newValue }
	}

	/// 高度
	public var height: CGFloat {
		get { return self.frame.size.height }
		set { self.frame.size.height = newValue }
	}

	/// 原点
	public var origin: CGPoint {
		get { return self.frame.origin }
		set { self.frame.origin = newValue }
	}

	/// 尺寸
	public var size: CGSize {
		get { return self.frame.size }
		set { self.frame.size = newValue }
	}

	/// 最大横坐标
	public var maxX: CGFloat {
		get { return self.x + self.width }
		set { self.frame.origin.x = newValue - self.width }
	}

	/// 最大纵坐标
	public var maxY: CGFloat {
		get { return self.y + self.height }
		set { self.frame.origin.y = newValue - self.height }
	}

	/// 中点横坐标
	public var centerX: CGFloat {
		get { return self.x + self.width * 0.5 }
		set { self.frame.origin.x = newValue - self.width * 0.5 }
	}

	/// 中点纵坐标
	public var centerY: CGFloat {
		get { return self.y + self.height * 0.5 }
		set { self.frame.origin.y = newValue - self.height * 0.5 }
	}

	/// 中点
	public var centre: CGPoint {
		get { return CGPoint(x: self.centerX, y: self.centerY) }
		set {
			self.centerX = newValue.x
			self.centerY = newValue.y
		}
	}
}

// MARK: - 快速设置阴影

public extension UIView {

	/// 默认的阴影色深
	fileprivate var defaultShadowOpacity: Float {
		return Float(0.65)
	}

	/// 默认的阴影偏移量 - X轴
	fileprivate var defaultShadowOffsetX: CGFloat {
		return 0.0.cgFloat
	}

	/// 默认的阴影偏移量 - Y轴
	fileprivate var defaultShadowOffsetY: CGFloat {
		return 2.0.cgFloat
	}

	/// 默认的阴影发散度
	fileprivate var defaultShadowRadius: CGFloat {
		return 3.0.cgFloat
	}

	/**
	设置阴影, 使用默认值(不透明度0.65, 横轴偏移0.0, 纵轴偏移2.0, 羽化半径3.0)
	*/
	public func configShadow() {
        self.layer.shadowOpacity = self.defaultShadowOpacity
        self.layer.shadowOffset  = CGSize(width: self.defaultShadowOffsetX, height: self.defaultShadowOffsetY)
        self.layer.shadowRadius  = self.defaultShadowRadius
	}

	/**
	设置阴影

	- parameter opacity: 不透明度
	- parameter offsetX: 横轴偏移
	- parameter offsetY: 纵轴偏移
	- parameter radius:  羽化半径
	*/
	public func configShadow(opacity: Double?, offsetX: Double?, offsetY: Double?, radius: Double?) {

		self.layer.shadowOpacity = (opacity == nil) ? self.defaultShadowOpacity : Float(opacity!)
		self.layer.shadowOffset  = CGSize(
			width: (offsetX == nil) ? self.defaultShadowOffsetX : offsetX!.cgFloat,
			height: (offsetY == nil) ? self.defaultShadowOffsetY : offsetY!.cgFloat
		)
		self.layer.shadowRadius  = (radius == nil) ? self.defaultShadowRadius : radius!.cgFloat
	}
}

// MARK: - 设置圆角半径和裁切

public extension UIView {

	/**
	设置圆角半径和裁切

	- parameter cornerRadius:  圆角半径
	- parameter masksToBounds: 是否裁切
	*/
	public func configCornerRadius(_ cornerRadius: Double, masksToBounds: Bool) {
		self.layer.cornerRadius = cornerRadius.cgFloat
		self.layer.masksToBounds = masksToBounds
	}
}

// MARK: - 设置右上角的图形角标
private let TAG_FOR_BADGE_LABEL = 999
public extension UIView {

	/**
	在右上角添加图形角标

	- parameter badgeValue: 角标文本
	*/
	public func addBadge(_ badgeValue: String) {
		self.addBadge(badgeValue, at: CGPoint(x: 1.0, y: 0.0))
	}

	/**
	在指定位置添加圆角角标

	- parameter badgeValue: 角标文本
	- parameter at:         位置(0.0~1.0)
	*/
	public func addBadge(_ badgeValue: String, at: CGPoint) {
		// 判断当前是否已经有角标
		if let badge = self.viewWithTag(TAG_FOR_BADGE_LABEL) as? UILabel {
			badge.text = badgeValue
			return
		}
		// 创建label
		let badge = UILabel(frame: CGRect.zero)
		badge.tag = TAG_FOR_BADGE_LABEL
		// 设置文本
		badge.text = badgeValue
		// 调整尺寸
		badge.font                = UIFont.systemFont(ofSize: 12.0)
		badge.sizeToFitWithTextSizeLimits(CGSIZE_MAX, andInsets: UIEdgeInsets.zero)
		badge.width = max(badge.width, badge.height) // 宽度至少应该与高度一致, 保证字符串长度较短时, label以圆形的方式显示
		// 设置各项属性
		badge.layer.cornerRadius  = badge.height * 0.5
		badge.layer.masksToBounds = true
		badge.backgroundColor     = UIColor.red
		badge.textColor           = UIColor.white
		self.addSubview(badge)

		badge.centerX = self.width * at.x
		badge.centerY = self.height * at.y
	}

	/**
	移除图形角标
	*/
	public func removeBadges() {
		self.viewWithTag(999)?.removeFromSuperview()
	}
}

// MARK: - 设置控件的加载状态效果

public extension UIView {

	/**
	开始加载, 在控件的中心会出现一个UIActivityIndicatorView, 附带动画效果
	*/
	public func startLoading() {
		if self.isNowLoading() {
			return
		}
		let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
		self.isHidden = true
		activityIndicator.centre = self.centre
		self.superview?.addSubview(activityIndicator)
		activityIndicator.startAnimating()
	}

	/**
	停止加载, UIActivityIndicatorView消失
	*/
	public func ceaseLoading() {
		if !self.isNowLoading() {
			return
		}
		if let superview = self.superview {
			for subview in superview.subviews {
				if subview.isKind(of: UIActivityIndicatorView.self) {
					let activityIndicator = subview as! UIActivityIndicatorView
					activityIndicator.stopAnimating()
					activityIndicator.removeFromSuperview()
					self.isHidden = false
				}
			}
		}
	}

	/**
	控件是否处于加载效果显示状态

	- returns: 布尔值
	*/
	fileprivate func isNowLoading() -> Bool {
		if let superview = self.superview {
			for subview in superview.subviews {
				if subview.isKind(of: UIActivityIndicatorView.self) {
					let activityIndicator = subview as! UIActivityIndicatorView
					return activityIndicator.isAnimating
				}
			}
		}
		return false
	}
}

// MARK: - 控件截图

public extension UIView {

	/**
	对控件进行截图

	- returns: 返回截图
	*/
	public func snapshot() -> UIImage? {
		let widthInPxl = self.width
		let heightInPxl = self.height
		// 准备截图
		let size = CGSize(width: widthInPxl, height: heightInPxl)
		var image: UIImage?
		UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
		if let context = UIGraphicsGetCurrentContext() {
			self.layer.render(in: context)
			image = UIGraphicsGetImageFromCurrentImageContext()
		}
		UIGraphicsEndImageContext()
		return image
	}

	/**
	对控件进行截图, 支持设置边缘缩进

	- parameter insets: 边缘缩进, 如缩进值为负数则视为0缩进

	- returns: 返回裁切后的截图
	*/
	public func snapshotWithEdgeInsets(_ insets: UIEdgeInsets) -> UIImage? {
		guard insets.top >= 0 && insets.left >= 0 && insets.bottom >= 0 && insets.right >= 0
			else { return self.snapshotWithEdgeInsets(UIEdgeInsets.zero) }

		let fullW = self.width
		let fullH = self.height
		let fullS = CGSize(width: fullW, height: fullH)

		let clippedW = self.width - (insets.left + insets.right)
		let clippedH = self.height - (insets.top + insets.bottom)
		let clippedX = insets.left
		let clippedY = insets.top
		let clippedR = CGRect(x: clippedX, y: clippedY, width: clippedW, height: clippedH)

		UIGraphicsBeginImageContextWithOptions(fullS, false, 0.0)
		var fullImage: UIImage?
		if let ctx = UIGraphicsGetCurrentContext() {
			self.layer.render(in: ctx)
			fullImage = UIGraphicsGetImageFromCurrentImageContext()
		}
		UIGraphicsEndImageContext()

		UIGraphicsBeginImageContextWithOptions(clippedR.size, false, 0.0)
		var clippedImage: UIImage?
		if let _ = UIGraphicsGetCurrentContext() {
			fullImage?.draw(in: CGRect(x: -clippedX, y: -clippedY, width: fullW, height: fullH))
			clippedImage = UIGraphicsGetImageFromCurrentImageContext()
		}
		UIGraphicsEndImageContext()
		return clippedImage
	}
}

