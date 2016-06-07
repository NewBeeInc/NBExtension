//
//  RefreshControl.swift
//  Aura
//
//  Created by keyOfVv on 8/24/15.
//  Copyright (c) 2015 com.sangebaba. All rights reserved.
//

import UIKit

// MARK: - KVO Context & Path
private var UIScrollViewContentOffsetContext = 0
private var UIPanGestureRecognizerStateContext = 1
private let KVOKeyPath = "contentOffset"
private let KVOGesture = "panGestureRecognizer.state"
private let promptA = "下拉刷新"
private let promptB = "松开刷新"
private let minRefreshingTimeInterval = 1.0

// MARK: - Constants
//private let alphaAnimationOffset = CGFloat(0.0)

// MARK: - Class Definition
class RefreshControl: UIControl {

	// MARK: Interface Elements
	@IBOutlet weak var iconImageView: UIImageView! {
		didSet {
			iconImageView.contentMode = .ScaleAspectFit
		}
	}
	@IBOutlet weak var promptLabel: UILabel! {
		didSet {
			promptLabel.font = UIFont.systemFontOfSize(12.0.cgFloat)
		}
	}
	@IBOutlet weak var loadingImageView: UIImageView! {
		didSet {
			loadingImageView.contentMode = .ScaleAspectFit
		}
	}

	// MARK: Stored Properties
	var isRefreshing: Bool = false

	var allowEnding: Bool = false

	override func awakeFromNib() {
		super.awakeFromNib()
		self.alpha = 0.0
		self.width = SCREEN_WIDTH
		self.height = CGFloat(44.0)
	}

	// 已经被添加至新的父控件上, 监听新父控件的contentOffset
	override func didMoveToSuperview() {
		guard let superview = superview
			where superview.isKindOfClass(UITableView.self)
		else {
			return
		}

        self.x    = CGFloat(0.0)
        self.maxY = CGFloat(0.0)
		superview.addObserver(self, forKeyPath: KVOKeyPath, options: NSKeyValueObservingOptions.New, context: &UIScrollViewContentOffsetContext)
		(superview as! UITableView).addObserver(self, forKeyPath: KVOGesture, options: .New, context: &UIPanGestureRecognizerStateContext)
	}

	override func layoutSubviews() {
		self.height = CGFloat(44.0)
		super.layoutSubviews()
	}

	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {

		switch context {
		case &UIScrollViewContentOffsetContext:
			guard let keyPath = keyPath, object = object
				where object.isKindOfClass(UITableView.self)
				else {
					return
			}

			if let value = (object as! UITableView).valueForKey(keyPath) as? NSValue {
				let contentOffset = value.CGPointValue()
				self.alpha = -(contentOffset.y) / self.height
				if !isRefreshing {
					if abs(contentOffset.y) <= height {
                        promptLabel.text    = promptA
                        iconImageView.image = UIImage(named: "cute")
					} else {
                        promptLabel.text    = promptB
                        iconImageView.image = UIImage(named: "stay")
					}
				}
			}
			break

		case &UIPanGestureRecognizerStateContext:
			guard let object = object, superview = superview, state = change?["new"] as? Int
				where object.isKindOfClass(UITableView.self) && superview.isKindOfClass(UITableView.self)
			else {
				return
			}
			// 1 - began
			// 2 - changed
			// 3 - ended
			if state == UIGestureRecognizerState.Ended.rawValue {
				if (superview as! UITableView).contentOffset.y < -height {
					beginRefreshing()
				}
			}
			break

		default:
			break
		}
	}
}

// MARK: - Interface
extension RefreshControl {

	class func refreshControl() -> RefreshControl {
		return BUNDLE_MAIN.loadNibNamed("RefreshControl", owner: nil, options: nil).first as! RefreshControl
	}

	func beginRefreshing() {
		// 如果当前正在刷新, 则直接返回
		guard let superview = superview
			where !self.isRefreshing && superview.isKindOfClass(UITableView.self)
		else {
			return
		}
		
		self.isRefreshing = true

		UIView.animateWithDuration(TIMEINTERVAL_ANIMATION_DEFAULT, animations: { () -> Void in
			log("begin=" + NSStringFromUIEdgeInsets((superview as! UITableView).contentInset))
			var originalInset = (superview as! UITableView).contentInset
			originalInset.top += self.height
			(superview as! UITableView).contentInset = originalInset
			log("begin=" + NSStringFromUIEdgeInsets((superview as! UITableView).contentInset))
			(superview as! UITableView).setContentOffset(CGPointMake(0, -self.height), animated: false)

			})

		self.promptLabel.hidden = true
		self.loadingImageView.hidden = false

		var images = [UIImage]()
		for i in 0 ..< 29 {
			// loading_grey_v2_00000
			var imageName = ""
			if i <= 9 {
				imageName = "loading_grey_v2_0000" + "\(i)"
			} else {
				imageName = "loading_grey_v2_000" + "\(i)"
			}
			let image = UIImage(named: imageName)!
			images.append(image)
		}
		self.loadingImageView.animationImages = images
		self.loadingImageView.animationDuration = TIMEINTERVAL_ANIMATION_DEFAULT * 5.0
		self.loadingImageView.animationRepeatCount = 0
		self.loadingImageView.startAnimating()

		self.iconImageView.image = UIImage(named: "work")

		self.sendActionsForControlEvents(UIControlEvents.ValueChanged)

		self.allowEnding = false
		delay(minRefreshingTimeInterval) { () -> () in
			self.allowEnding = true
		}
	}

	func endRefreshing() {

		if !isRefreshing { return }

		if !allowEnding {
			delay(minRefreshingTimeInterval, closure: { () -> () in
				self.endRefreshingAnimation()
			})
		} else {
			self.endRefreshingAnimation()
		}
	}

	private func endRefreshingAnimation() {
		if let superview = self.superview {
			if superview.isKindOfClass(UIScrollView.self) {

				UIView.animateWithDuration(TIMEINTERVAL_ANIMATION_DEFAULT, animations: { () -> Void in
					(superview as! UITableView).setContentOffset(CGPointMake(0, 0), animated: false)
					log("end=" + NSStringFromUIEdgeInsets((superview as! UITableView).contentInset))
					var originalInset = (superview as! UITableView).contentInset
					originalInset.top -= self.height
					(superview as! UITableView).contentInset = originalInset
					log("end=" + NSStringFromUIEdgeInsets((superview as! UITableView).contentInset))
					}, completion: { (finished) -> Void in
						self.isRefreshing = false
						self.promptLabel.hidden = false
						self.loadingImageView.stopAnimating()
						self.loadingImageView.hidden = true
						self.loadingImageView.animationImages = nil
				})
			}
		}
	}

	func destroy() {
		superview?.removeObserver(self, forKeyPath: KVOKeyPath, context: &UIScrollViewContentOffsetContext)
		superview?.removeObserver(self, forKeyPath: KVOGesture, context: &UIPanGestureRecognizerStateContext)
	}
}
