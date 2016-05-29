//
//  UIViewControllerExtension.swift
//  Aura
//
//  Created by keyOfVv on 1/8/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIViewController的弹框显示功能

public extension UIViewController {

	/**
	从当前控制器的视图中弹出子控制器的视图

	- parameter viewController: 子控制器
	- parameter rect:           子控制器的视图尺寸位置
	*/
	public func popUpViewController(viewController: UIViewController, inRect rect: CGRect) {
		// 加载子控制器
		self.addChildViewController(viewController)
		// 设置子控制器视图尺寸和位置
		viewController.view.frame = rect
		// 手动触发子控制器的view life circle
		viewController.beginAppearanceTransition(true, animated: false)
		viewController.view.alpha = 0.0
		UIApplication.sharedApplication().keyWindow?.addSubview(viewController.view)
		viewController.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
		UIView.transitionWithView(viewController.view, duration: TIMEINTERVAL_ANIMATION_DEFAULT, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
			viewController.view.alpha = 1.0
			viewController.view.transform = CGAffineTransformIdentity
			}) { (finished) -> Void in
				viewController.endAppearanceTransition()
		}
	}

	// FIXME: 此方法的使用有一定的危险性, 思路需要完善
	/**
	从父控制器的视图中消失
	*/
	public func popOff() {
		if self.parentViewController == nil { return }

		self.beginAppearanceTransition(false, animated: false)
		UIView.transitionWithView(self.view, duration: TIMEINTERVAL_ANIMATION_DEFAULT, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
			self.view.alpha = 0.0
			self.view.transform = CGAffineTransformScale(self.view.transform, 1.3, 1.3)
			}) { (finished) -> Void in
				self.view.removeFromSuperview()
				self.endAppearanceTransition()
				self.removeFromParentViewController()
		}
	}

	@available(*, unavailable, message="don't call this method directly")
	public func dismiss() {
		if self.navigationController == nil {
			self.dismissViewControllerAnimated(true, completion: nil)
		} else {
			self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
		}
	}

}