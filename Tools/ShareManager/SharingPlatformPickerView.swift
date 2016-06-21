//
//  SharingPlatformPickerView.swift
//  Aura
//
//  Created by keyOfVv on 11/23/15.
//  Copyright © 2015 com.sangebaba. All rights reserved.
//

import UIKit

private let buttonWidth = 48.0.cgFloat
private let buttonHeight = 72.0.cgFloat

private let containerHeight = 96.0.cgFloat

@objc enum ShareChannel: Int {
	case WeChatSession
	case WeChatTimeLine
	case Weibo

	static var count: Int = {
		var max: Int = 1
		while let _ = ShareChannel(rawValue: max) {
			max += 1
		}
		return max
	}()
}

// MARK: - Protocol
@objc protocol SharingPlatformPickerViewDelegate: NSObjectProtocol {
	optional func sharingPlatformPickerView(sharingPlatformPickerView: SharingPlatformPickerView, didSelectShareChannel channel: ShareChannel) -> Void
}

// MARK: - Class definition
class SharingPlatformPickerView: FocusView {

	// MARK: Collection Type

	// MARK: Interface Elements

	lazy var containerView: UIView = {
		let view = UIView(frame: CGRectZero)
		view.backgroundColor = UIColor.whiteColor()
		view.configShadow()
		view.configCornerRadius(3.0, masksToBounds: false)
		self.addSubview(view)
		return view
	}()

	lazy var weChatSessionButton: NBButton = {
		let button = NBButton(type: .System)
		self.configButton(button, imageNamed: "wechat_session", title: "微信", tag: ShareChannel.WeChatSession.rawValue)
		return button
	}()

	lazy var weChatMomentButton: NBButton = {
		let button = NBButton(type: .System)
		self.configButton(button, imageNamed: "wechat_moments", title: "朋友圈", tag: ShareChannel.WeChatTimeLine.rawValue)
		return button
	}()

	lazy var weiboButton: NBButton = {
		let button = NBButton(type: .System)
		self.configButton(button, imageNamed: "sina", title: "微博", tag: ShareChannel.Weibo.rawValue)
		return button
	}()

	// MARK: Stored Properties

	weak var delegate: SharingPlatformPickerViewDelegate?

	// MARK: Initializer

	override init(frame: CGRect) {
		super.init(frame: frame)
		if #available(iOS 8.0, *) {
			blurView.frame = self.bounds
			blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SharingPlatformPickerView.hide)))
		} else {
			self.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
			self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SharingPlatformPickerView.hide)))
		}

		self.containerView.width = self.width - 16.0
		self.containerView.height = containerHeight
		self.containerView.x = 8.0.cgFloat
		self.containerView.maxY = self.height - 8.0

		let padding = (self.containerView.width - buttonWidth * ShareChannel.count.cgFloat) / (ShareChannel.count.cgFloat + 1.0)

		// 微信聊天
		self.weChatSessionButton.width = buttonWidth
		self.weChatSessionButton.height = buttonHeight
		self.weChatSessionButton.x = padding
		self.weChatSessionButton.centerY = containerHeight * 0.5

		// 朋友圈
		self.weChatMomentButton.width = buttonWidth
		self.weChatMomentButton.height = buttonHeight
		self.weChatMomentButton.x = padding * 2.0 + buttonWidth
		self.weChatMomentButton.centerY = containerHeight * 0.5

		// weibo
		self.weiboButton.width = buttonWidth
		self.weiboButton.height = buttonHeight
		self.weiboButton.maxX = self.containerView.width - padding
		self.weiboButton.centerY = containerHeight * 0.5
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	func didClickButton(sender: UIButton) {
		if self.delegate?.respondsToSelector(#selector(SharingPlatformPickerViewDelegate.sharingPlatformPickerView(_:didSelectShareChannel:))) == true {
			self.delegate!.sharingPlatformPickerView!(self, didSelectShareChannel: ShareChannel(rawValue: sender.tag)!)
		}
		self.hide()
	}

	private func configButton(button: NBButton, imageNamed: String, title: String, tag: Int) {
		button.tag = tag
		button.setImage(UIImage(named: imageNamed), forState: .Normal)
		button.setTitle(title, forState: .Normal)
		button.layoutType = .TopImageBottomTitle
		button.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
		button.titleLabel?.font = FONT_CONTENT_SUB
		button.titleEdgeInsets = UIEdgeInsetsMake(5.0, 0.0, 0.0, 0.0)
		button.addTarget(self, action: #selector(NoInstrumentPromptView.didClickButton(_:)), forControlEvents: .TouchUpInside)
		self.containerView.addSubview(button)
	}
}

// MARK: - Interface
extension SharingPlatformPickerView {

	/// 快速构造方法
	///
	/// - parameter delegate: 代理
	convenience init(delegate: SharingPlatformPickerViewDelegate?) {
		self.init(frame: SCREEN_BOUNDS)
		self.delegate = delegate
	}

	/// 显示
	///
	func show() {
		UIApplication.sharedApplication().keyWindow?.addSubview(self)
		self.containerView.transform = CGAffineTransformMakeTranslation(0.0, self.containerView.height)
		UIView.transitionWithView(self, duration: TIMEINTERVAL_ANIMATION_DEFAULT, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
			self.containerView.transform = CGAffineTransformIdentity
			if #available(iOS 8.0, *) {
			    self.blurView.effect = UIBlurEffect(style: .Dark)
			}
			}, completion: { (finished) -> Void in

		})
	}

	/// 隐藏
	///
    func hide() {
		UIView.transitionWithView(self, duration: TIMEINTERVAL_ANIMATION_DEFAULT, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
			self.containerView.transform = CGAffineTransformTranslate(self.containerView.transform, 0.0, self.containerView.height)
			if #available(iOS 8.0, *) {
				self.blurView.effect = nil
			}
			}, completion: { (finished) -> Void in
				self.removeFromSuperview()
		})
	}
}
