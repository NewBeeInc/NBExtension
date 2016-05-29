//
//  UIScreenExtension.swift
//  Aura
//
//  Created by keyOfVv on 1/8/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIScreen尺寸的便捷访问

/// 当前屏幕宽度
public let SCREEN_WIDTH  = UIScreen.width

/// 当前屏幕高度
public let SCREEN_HEIGHT = UIScreen.height

/// 当前屏幕大小
public let SCREEN_SIZE   = UIScreen.size

/// 当前屏幕尺寸位置
public let SCREEN_BOUNDS = UIScreen.Bounds

/// 当前屏幕的点-像素比
public let SCREEN_SCALE  = UIScreen.mainScreen().scale

public extension UIScreen {

	/// 屏幕宽度
	@available(*, deprecated, message="use width instead")
	class var screenWidth: CGFloat {
		get {
			return UIScreen.mainScreen().bounds.width
		}
	}

	/// 屏幕高度
	@available(*, deprecated, message="use height instead")
	class var screenHeight: CGFloat {
		get {
			return UIScreen.mainScreen().bounds.height
		}
	}

	/// 屏幕大小
	@available(*, deprecated, message="use size instead")
	class var screenSize: CGSize {
		get {
			return UIScreen.mainScreen().bounds.size
		}
	}

	/// 屏幕尺寸位置
	@available(*, deprecated, message="use Bounds instead")
	class var screenBounds: CGRect {
		get {
			return UIScreen.mainScreen().bounds
		}
	}

	/// 屏幕尺寸位置
	public class var Bounds: CGRect {
		return UIScreen.mainScreen().bounds
	}

	/// 屏幕宽度
	public class var width: CGFloat {
		return UIScreen.Bounds.width
	}

	/// 屏幕高度
	public class var height: CGFloat {
		return UIScreen.Bounds.height
	}

	/// 屏幕大小
	public class var size: CGSize {
		return UIScreen.Bounds.size
	}
}
