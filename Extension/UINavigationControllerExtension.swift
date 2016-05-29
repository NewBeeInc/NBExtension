//
//  UINavigationControllerExtension.swift
//  Aura
//
//  Created by keyOfVv on 1/8/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UINavigationController扩展, 快速实现UINavigationBar的外观调整
public extension UINavigationController {

	/**
	隐藏导航栏的底部分隔边线

	- parameter hidden: 隐藏/显示
	*/
	public func setBottomSeparatorHidden(hidden: Bool) {
		for naviBarSubview in self.navigationBar.subviews {
			if (naviBarSubview.isKindOfClass(NSClassFromString("_UINavigationBarBackground")!)) {
				let navigationBarBackground: UIView = naviBarSubview
				for navigationBarBackgroundSubview in navigationBarBackground.subviews {
					if (navigationBarBackgroundSubview.isKindOfClass(UIImageView)) {
						let imageView: UIImageView = navigationBarBackgroundSubview as! UIImageView
						imageView.hidden = hidden
					}
				}
			}
		}
	}

	/**
	设置导航栏背景色, 注: UINavigationBar的translucent属性需设置为false, 否则本方法不能达到预期的效果, 导航栏最上层会有一层毛玻璃蒙版遮挡;

	- parameter color: 颜色
	*/
	public func setBarBackgroundColor(color: UIColor) {
		for naviBarSubview in self.navigationBar.subviews {
			if (naviBarSubview.isKindOfClass(NSClassFromString("_UINavigationBarBackground")!)) {
				let navigationBarBackground: UIView = naviBarSubview
				navigationBarBackground.backgroundColor = color
			}
		}
	}

	//	func setTitleLabelTextColor(color: UIColor) {
	//		for naviBarSubview in self.navigationBar.subviews {
	//			if (naviBarSubview.isKindOfClass(NSClassFromString("UINavigationItemView"))) {
	//				let navigationItemView: UIView = naviBarSubview as! UIView
	//				for navigationBarBackgroundSubview in navigationBarBackground.subviews {
	//					if (navigationBarBackgroundSubview.isKindOfClass(UIImageView)) {
	//						let imageView: UIImageView = navigationBarBackgroundSubview as! UIImageView
	//						imageView.hidden = hidden
	//					}
	//				}
	//			}
	//		}
	//	}

	@available(*, unavailable, message="don't call this method directly")
	internal func pop() {
		self.popViewControllerAnimated(true)
	}
	
}
