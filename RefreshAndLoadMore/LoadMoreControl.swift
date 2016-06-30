//
//  LoadMoreControl.swift
//  Aura
//
//  Created by keyOfVv on 9/9/15.
//  Copyright (c) 2015 com.sangebaba. All rights reserved.
//

import UIKit

// MARK: - KVO Context & Path
private var UIScrollViewContentOffsetContext = 0
private var UIScrollViewContentSizeContext = 1
private var UIPanGestureRecognizerStateContext = 2
private let KVOKeyPath = "contentOffset"
private let KVOKeyPathContentSize = "contentSize"
private let KVOGesture = "panGestureRecognizer.state"
private let minRefreshingTimeInterval = 1.0

// MARK: - Constants
private let alphaAnimationOffset = CGFloat(22.0)

// MARK: - Class Definition
class LoadMoreControl: UIControl {

	// MARK: Interface Elements

	private lazy var button: NBButton = {
		let btn = NBButton(layoutType: LayoutType.Normal)
		btn.setImage(UIImage(named: "loading_grey_v2_00000"), forState: UIControlState.Normal)
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
		btn.animationImages = images
		btn.animationDuration = TIMEINTERVAL_ANIMATION_DEFAULT * 5.0
		btn.animationRepeatCount = 0
		self.addSubview(btn)
		return btn
	}()

	// MARK: Stored Properties

	/// a flag indicates if is loading more
	var isLoadingMore: Bool = false
	var allowEnding: Bool = false

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func didMoveToSuperview() {
		// once added to superview...
		// 1. make sure superview is class of UITableView
		guard let superview = superview where superview.isKindOfClass(UITableView.self)
			else { return }
		let tableView = superview as! UITableView
		// 2. check out superview (UITableView) content height
		let contentH = tableView.contentSize.height
		dog(contentH)
		// 3. checkout superview's visible height
		let visibleH = tableView.height - (tableView.contentInset.top + tableView.contentInset.bottom)
		dog(visibleH)

		self.x = CGFloat(0.0)

		if contentH < visibleH {
//			tableView.contentSize = CGSizeMake(SCREEN_WIDTH, visibleH)
			self.y = visibleH
		} else {
			self.y = contentH
		}
		self.width = SCREEN_WIDTH
		self.height = 44.0.cgFloat
		superview.addObserver(self, forKeyPath: KVOKeyPath, options: NSKeyValueObservingOptions.New, context: &UIScrollViewContentOffsetContext)
		superview.addObserver(self, forKeyPath: KVOKeyPathContentSize, options: NSKeyValueObservingOptions.New, context: &UIScrollViewContentSizeContext)
		(superview as! UITableView).addObserver(self, forKeyPath: KVOGesture, options: NSKeyValueObservingOptions.New, context: &UIPanGestureRecognizerStateContext)
	}

	override func layoutSubviews() {
		self.height = CGFloat(44.0)
		super.layoutSubviews()
		self.button.width = SCREEN_WIDTH
		self.button.height = self.height
		self.button.x = 0.0
		self.button.y = 0.0
		dog(self.button)
	}

	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		switch context {
		case &UIScrollViewContentOffsetContext:
			guard let superview = superview
				where superview.isKindOfClass(UITableView.self) && !self.isLoadingMore
			else {
				return
			}

			let contentOffset = (superview as! UITableView).contentOffset
			self.alpha = (contentOffset.y + (superview as! UIScrollView).height - (superview as! UIScrollView).contentSize.height - alphaAnimationOffset) / self.height
//			dog("\(self.alpha)")
			if self.alpha < 1.0 {
//				self.button.setTitle("上拉加载", forState: UIControlState.Normal)
			} else {
//				self.button.setTitle("松开加载", forState: UIControlState.Normal)
			}
			break
		case &UIScrollViewContentSizeContext:
			guard let superview = superview
				where superview.isKindOfClass(UITableView.self)
			else {
				return
			}
			let contentSizeHeight = (superview as! UITableView).contentSize.height
			let superviewVisibleHeight = (superview as! UITableView).height - ((superview as! UITableView).contentInset.top + (superview as! UITableView).contentInset.bottom)

			if contentSizeHeight < superviewVisibleHeight {
				(superview as! UIScrollView).contentSize = CGSizeMake(SCREEN_WIDTH, superviewVisibleHeight)
				self.y = superviewVisibleHeight
			} else {
				self.y = contentSizeHeight
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
				if superview.height - ((superview as! UITableView).contentSize.height - (superview as! UITableView).contentOffset.y) > 65.0 {
					beginLoadingMore()
				}
			}
			break
		default:
			break
		}
	}
}

// MARK: - Interface
extension LoadMoreControl {

	func beginLoadingMore() {

		// 0. 如果当前正在加载, 则直接返回
		guard let superview = superview where !isLoadingMore && superview.isKindOfClass(UITableView.self)
			else { return }
		let tableView = superview as! UITableView
		// 1. 开始加载旧的评价
		self.isLoadingMore = true

		if tableView.contentOffset.y != self.height {
			UIView.animateWithDuration(TIMEINTERVAL_ANIMATION_DEFAULT, animations: { () -> Void in
				var originalInset = (superview as! UITableView).contentInset
				originalInset.bottom += self.height
				tableView.contentInset = originalInset
				let contentH = tableView.contentSize.height
				let tableViewH = tableView.height
				tableView.setContentOffset(CGPointMake(0, contentH + self.height - tableViewH), animated: false)
			})
		}


		self.button.startAnimating()

		self.sendActionsForControlEvents(UIControlEvents.ValueChanged)

		self.allowEnding = false
		delay(minRefreshingTimeInterval) { () -> () in
			self.allowEnding = true
		}
	}

	func endLoadingMore() {
		if !allowEnding {
			delay(minRefreshingTimeInterval, closure: { () -> () in
				self.endLoadingAnimation()
			})
		} else {
			self.endLoadingAnimation()
		}
	}

	private func endLoadingAnimation() {
		if let superview = self.superview {
			if superview.isKindOfClass(UIScrollView.self) {
				UIView.animateWithDuration(TIMEINTERVAL_ANIMATION_DEFAULT, animations: { () -> Void in
					var originalInset = (superview as! UITableView).contentInset
					originalInset.bottom -= self.height
					(superview as! UIScrollView).contentInset = originalInset
					}, completion: { (finished) -> Void in
						self.isLoadingMore = false
						self.button.stopAnimating()
//						self.button.animationImages = nil
				})
			}
		}
	}

	func destroy() {
		superview?.removeObserver(self, forKeyPath: KVOKeyPath, context: &UIScrollViewContentOffsetContext)
		superview?.removeObserver(self, forKeyPath: KVOKeyPathContentSize, context: &UIScrollViewContentSizeContext)
		superview?.removeObserver(self, forKeyPath: KVOGesture, context: &UIPanGestureRecognizerStateContext)
	}
}
