//
//  PromptView.swift
//  Aura
//
//  Created by keyOfVv on 8/27/15.
//  Copyright (c) 2015 com.sangebaba. All rights reserved.
//

import UIKit

private let coverColor = UIColor(white: 1.0, alpha: 0.8)
private let embedColor = UIColor.clearColor()

// MARK: - Class Definition
class PromptView: FocusView {

	enum Type: Int {
		case Progress = 0
		case Failure
	}

	// MARK: Interface Elements
	@IBOutlet weak var animationImageView: UIImageView! {
		didSet {
			let count = 12
			var images = [UIImage]()
			for i in 1 ... count {
				var imageName = "page_loading_"
				if i < 10 {
					imageName += "0\(i)"
				} else {
					imageName += "\(i)"
				}
				let image = UIImage(named: imageName)
				images.append(image!)
			}
			animationImageView.animationImages = images
			animationImageView.animationDuration = TIMEINTERVAL_ANIMATION_DEFAULT * 2.8
			animationImageView.animationRepeatCount = 0
		}
	}
	@IBOutlet weak var promptLabel: UILabel! {
		didSet {
			promptLabel.font = UIFont.systemFontOfSize(13.5)
			promptLabel.textColor = UIColor.ultraLightGrayColor()
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		if #available(iOS 8.0, *) {
		    blurView.frame = self.bounds
		} else {
		    // Fallback on earlier versions
		}
	}
}

// MARK: - Public
extension PromptView {

	class func progressView() -> PromptView {
		let promptView = PromptView.promptView()
		promptView.animationImageView.startAnimating()
		promptView.promptLabel.text = "正在加载..."
		return promptView
	}
    
    @available(*, deprecated, message="use - noDataView(_:) instead")
	class func noDataView() -> PromptView {
		return self.noDataView("暂无数据，请打开定位/检查网络并刷新")
	}
    
    class func noDataView(withText: String) -> PromptView {
        let promptView = PromptView.promptView()
        promptView.animationImageView.image = UIImage(named: "nodata")
        promptView.promptLabel.text = withText
        return promptView
    }

	/// 生成一个failureView, 使用指定的文本
	///
	/// - parameter withText: 文本;
	/// - returns:	返回PromptView实例
	class func failureView(withText: String) -> PromptView {
		let promptView = PromptView.promptView()
		promptView.animationImageView.image = UIImage(named: "nodata")
		promptView.promptLabel.text = withText
		return promptView
	}

	func showOn(view: UIView) {
		view.addSubview(self)
		self.center = CGPointMake(view.width * 0.5, view.height * 0.5)
	}

}

// MARK: - Private
extension PromptView {

	class func promptView() -> PromptView {
		return BUNDLE_MAIN.loadNibNamed("PromptView", owner: nil, options: nil).first as! PromptView
	}

	private class func isShowing() -> Bool {
		if let window = UIApplication.sharedApplication().keyWindow {
			for subview in window.subviews {
				if subview.isKindOfClass(PromptView.self) {
					return true
				}
			}
		}
		return false
	}

	private class func isShowingProgressIn(view: UIView?) -> Bool {
		if let targetView = view {
			for subview in targetView.subviews {
				if subview.isKindOfClass(PromptView.self) {
					if subview.tag == Type.Progress.rawValue {
						return true
					}
				}
			}
		}
		return false
	}

	private class func isShowingFailureIn(view: UIView?) -> Bool {
		if let targetView = view {
			for subview in targetView.subviews {
				if subview.isKindOfClass(PromptView.self) {
					if subview.tag == Type.Failure.rawValue {
						return true
					}
				}
			}
		}
		return false
	}
}

// MARK: - Deprecated
extension PromptView {

	class func show() {
		if !self.isShowing() {
			let promptView = PromptView.promptView()
			if let window = UIApplication.sharedApplication().keyWindow {
				promptView.frame = window.bounds
				window.addSubview(promptView)
				promptView.animationImageView.startAnimating()
				if #available(iOS 8.0, *) {
					promptView.blurView.effect = UIBlurEffect(style: .Dark)
				} else {
					promptView.backgroundColor = coverColor
				}
				promptView.promptLabel.text = "正在加载..."
				UIView.animateWithDuration(TIMEINTERVAL_ANIMATION_DEFAULT, animations: { () -> Void in
					if #available(iOS 8.0, *) {
						promptView.blurView.effect = UIBlurEffect(style: .Dark)
					} else {
						promptView.alpha = 1.0
					}
				})
			}
		}
	}

	class func hide() {
		if self.isShowing() {
			if let window = UIApplication.sharedApplication().keyWindow {
				for subview in window.subviews {
					if subview.isKindOfClass(PromptView.self) {
						UIView.animateWithDuration(TIMEINTERVAL_ANIMATION_DEFAULT, animations: { () -> Void in
							if #available(iOS 8.0, *) {
								(subview as! PromptView).blurView.effect = nil
							} else {
								(subview as! PromptView).alpha = 0.0
							}
							}, completion: { (finished) -> Void in
								subview.removeFromSuperview()
						})
					}
				}
			}
		}
	}

//	@available(iOS, deprecated=1.0.3)
//	class func showProgressIn(view: UIView?) {
//		self.showProgressIn(view, message: "正在加载...")
//	}
//
//	@available(iOS, deprecated=1.0.3)
//	class func showProgressIn(view: UIView?, message: String) {
//		if let targetView = view {
//			if !self.isShowingProgressIn(targetView) {
//				let promptView = PromptView.promptView()
//				promptView.tag = Type.Progress.rawValue
//				promptView.backgroundColor = embedColor
//				promptView.frame = targetView.bounds
//				targetView.addSubview(promptView)
//				promptView.animationImageView.startAnimating()
//				promptView.promptLabel.text = message
//				UIView.animateWithDuration(TIMEINTERVAL_ANIMATION_DEFAULT, animations: { () -> Void in
//					promptView.alpha = 1.0
//				})
//			}
//		} else {
//			self.show()
//		}
//	}
//
//	@available(iOS, deprecated=1.0.3)
//	class func hideProgressIn(view: UIView?) {
//		if let targetView = view {
//			for subview in targetView.subviews {
//				if subview.isKindOfClass(PromptView.self) {
//					if subview.tag == Type.Progress.rawValue {
//						UIView.animateWithDuration(TIMEINTERVAL_ANIMATION_DEFAULT, animations: { () -> Void in
//							(subview as! PromptView).alpha = 0.0
//							}, completion: { (finished) -> Void in
//								subview.removeFromSuperview()
//						})
//					}
//				}
//			}
//
//		} else {
//			self.hide()
//		}
//	}

//	@available(iOS, deprecated=1.0.3)
//	class func showFailureIn(view: UIView?) {
//		self.showFailureIn(view, message: "当前暂无数据，请检查网络并刷新")
//	}

//	@available(iOS, deprecated=1.0.3)
//	class func showFailureIn(view: UIView?, message: String) {
//		if let targetView = view {
//			if !self.isShowingFailureIn(targetView) {
//				let promptView = PromptView.promptView()
//				promptView.tag = Type.Failure.rawValue
//				promptView.backgroundColor = embedColor
//				promptView.frame = targetView.bounds
//				targetView.addSubview(promptView)
//				promptView.animationImageView.image = UIImage(named: "nodata")
//				promptView.promptLabel.text = message
//				UIView.animateWithDuration(TIMEINTERVAL_ANIMATION_DEFAULT, animations: { () -> Void in
//					promptView.alpha = 1.0
//				})
//			}
//		}
//	}

//	@available(iOS, deprecated=1.0.3)
//	class func hideFailureIn(view: UIView?) {
//		if let targetView = view {
//			for subview in targetView.subviews {
//				if subview.isKindOfClass(PromptView.self) {
//					if subview.tag == Type.Failure.rawValue {
//						UIView.animateWithDuration(TIMEINTERVAL_ANIMATION_DEFAULT, animations: { () -> Void in
//							(subview as! PromptView).alpha = 0.0
//							}, completion: { (finished) -> Void in
//								subview.removeFromSuperview()
//						})
//					}
//				}
//			}
//		}
//	}
}








