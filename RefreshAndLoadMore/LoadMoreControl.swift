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

	// MARK: Interafce Elements

	private var button: NBButton?

	@IBOutlet weak var loadingImageView: UIImageView! {
		didSet {
			loadingImageView.hidden = true
		}
	}
	@IBOutlet weak var promptLabel: UILabel! {
		didSet {
			promptLabel.hidden = false
		}
	}

	// MARK: Stored Properties

	/// a flag indicates if is loading more
	var isLoadingMore: Bool = false
	var allowEnding: Bool = false

	override func awakeFromNib() {
		super.awakeFromNib()
		self.alpha = 1.0
		self.width = SCREEN_WIDTH
		self.height = CGFloat(44.0)
	}

	override func didMoveToSuperview() {
		guard let superview = superview
			where superview.isKindOfClass(UITableView.self)
			else {
				return
		}

		self.x = CGFloat(0.0)

		let contentSizeHeight = (superview as! UITableView).contentSize.height
		let superviewVisibleHeight = superview.height - ((superview as! UIScrollView).contentInset.top + (superview as! UIScrollView).contentInset.bottom)
		if contentSizeHeight < superviewVisibleHeight {
			(superview as! UIScrollView).contentSize = CGSizeMake(SCREEN_WIDTH, superviewVisibleHeight)
			self.y = superviewVisibleHeight
		} else {
			self.y = contentSizeHeight
		}
		superview.addObserver(self, forKeyPath: KVOKeyPath, options: NSKeyValueObservingOptions.New, context: &UIScrollViewContentOffsetContext)
		superview.addObserver(self, forKeyPath: KVOKeyPathContentSize, options: NSKeyValueObservingOptions.New, context: &UIScrollViewContentSizeContext)
		(superview as! UITableView).addObserver(self, forKeyPath: KVOGesture, options: NSKeyValueObservingOptions.New, context: &UIPanGestureRecognizerStateContext)
	}

	override func layoutSubviews() {
		self.height = CGFloat(44.0)
		super.layoutSubviews()
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
			if self.alpha < 1.0 {
				self.promptLabel.text = "上拉加载"
			} else {
				self.promptLabel.text = "松开加载"
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

	class func loadMoreControl() -> LoadMoreControl {
		return BUNDLE_MAIN.loadNibNamed("LoadMoreControl", owner: nil, options: nil).first as! LoadMoreControl
	}

	func beginLoadingMore() {

		// 0. 如果当前正在加载, 则直接返回
		guard let superview = superview
			where !isLoadingMore && superview.isKindOfClass(UITableView.self)
		else {
			return
		}
		
		// 1. 开始加载旧的评价
		self.isLoadingMore = true

		if (superview as! UITableView).contentOffset.y != self.height {
			UIView.animateWithDuration(TIMEINTERVAL_ANIMATION_DEFAULT, animations: { () -> Void in
				var originalInset = (superview as! UITableView).contentInset
				originalInset.bottom += self.height
				(superview as! UIScrollView).contentInset = originalInset
				let contentH = (superview as! UITableView).contentSize.height
				let tableViewH = (superview as! UITableView).height
				(superview as! UITableView).setContentOffset(CGPointMake(0, contentH + self.height - tableViewH), animated: false)
			})
		}

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
		superview?.removeObserver(self, forKeyPath: KVOKeyPathContentSize, context: &UIScrollViewContentSizeContext)
		superview?.removeObserver(self, forKeyPath: KVOGesture, context: &UIPanGestureRecognizerStateContext)
	}
}
