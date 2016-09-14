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

	fileprivate lazy var button: NBButton = {
		let btn = NBButton(layoutType: LayoutType.normal)
		btn.setImage(UIImage(named: "loading_grey_v2_00000"), for: UIControlState())
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

	/// a flag indicates if is refreshing
	var isRefreshing: Bool = false
	var allowEnding: Bool = false

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	// 已经被添加至新的父控件上, 监听新父控件的contentOffset
	override func didMoveToSuperview() {
		guard let superview = superview , superview.isKind(of: UITableView.self)
			else { return }
		let tableView = superview as! UITableView
		self.height = 44.0.cgFloat
        self.x    = CGFloat(0.0)
        self.maxY = CGFloat(0.0)
		self.width = SCREEN_WIDTH
		tableView.addObserver(self, forKeyPath: KVOKeyPath, options: NSKeyValueObservingOptions.new, context: &UIScrollViewContentOffsetContext)
		tableView.addObserver(self, forKeyPath: KVOGesture, options: .new, context: &UIPanGestureRecognizerStateContext)
	}

	override func layoutSubviews() {
		self.height = CGFloat(44.0)
		super.layoutSubviews()
		self.button.width = SCREEN_WIDTH
		self.button.height = self.height
		self.button.x = 0.0
		self.button.y = 0.0
	}

	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		guard let keyPath = keyPath, let object = object
			, (object as AnyObject).isKind(of: UITableView.self)
			else {
				return
		}
		let tableView = object as! UITableView

		switch context?.load(as: Int.self) {
		case UIScrollViewContentOffsetContext?:
			if let value = tableView.value(forKey: keyPath) as? NSValue {
				let contentOffset = value.cgPointValue
				if !self.isRefreshing {
					self.alpha = -(contentOffset.y + tableView.contentInset.top) / self.height
				}

				if !isRefreshing {
					if abs(contentOffset.y) <= height {
					} else {
					}
				}
			}
			break

		case UIPanGestureRecognizerStateContext?:
			guard let state = change?[NSKeyValueChangeKey.newKey] as? Int
				else { return }
			// 1 - began
			// 2 - changed
			// 3 - ended
			if state == UIGestureRecognizerState.ended.rawValue {
				if tableView.contentOffset.y + tableView.contentInset.top < -self.height {
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

	func beginRefreshing() {
		dog(self.isRefreshing)
		// 如果当前正在刷新, 则直接返回
		guard let superview = superview
			, !self.isRefreshing && superview.isKind(of: UITableView.self)
		else {
			return
		}
		
		self.isRefreshing = true
		self.alpha = 1.0

		UIView.animate(withDuration: TIMEINTERVAL_ANIMATION_DEFAULT, animations: { () -> Void in
		dog("begin=" + NSStringFromUIEdgeInsets((superview as! UITableView).contentInset))
			var originalInset = (superview as! UITableView).contentInset
			originalInset.top += self.height
			(superview as! UITableView).contentInset = originalInset
		dog("begin=" + NSStringFromUIEdgeInsets((superview as! UITableView).contentInset))
			(superview as! UITableView).setContentOffset(CGPoint(x: 0, y: -self.height), animated: false)

			})

		self.button.startAnimating()

		self.sendActions(for: UIControlEvents.valueChanged)

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

	fileprivate func endRefreshingAnimation() {
		if let superview = self.superview {
			if superview.isKind(of: UIScrollView.self) {

				UIView.animate(withDuration: TIMEINTERVAL_ANIMATION_DEFAULT, animations: { () -> Void in
					(superview as! UITableView).setContentOffset(CGPoint(x: 0, y: 0), animated: false)
				dog("end=" + NSStringFromUIEdgeInsets((superview as! UITableView).contentInset))
					var originalInset = (superview as! UITableView).contentInset
					originalInset.top -= self.height
					(superview as! UITableView).contentInset = originalInset
				dog("end=" + NSStringFromUIEdgeInsets((superview as! UITableView).contentInset))
					}, completion: { (finished) -> Void in
						self.isRefreshing = false
						self.button.stopAnimating()
//						self.button.animationImages = nil
				})
			}
		}
	}

	func destroy() {
		superview?.removeObserver(self, forKeyPath: KVOKeyPath, context: &UIScrollViewContentOffsetContext)
		superview?.removeObserver(self, forKeyPath: KVOGesture, context: &UIPanGestureRecognizerStateContext)
	}
}
