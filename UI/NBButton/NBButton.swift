//
//  NBButton.swift
//  NBButton
//
//  Created by Ke Yang on 4/20/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

/*
 * 功能:
 * - 可自定义图片与标题的相对位置, 包括左右对调和上下排列.
 *
 */

import UIKit
import KEYExtension

@objc public enum LayoutType: Int {
	case normal
	case leftTitleRightImage
	case topTitleBottomImage
	case topImageBottomTitle
}

open class NBButton: UIButton {

	// MARK: stored property

	/// size of title
	fileprivate var ttlF = CGRect.zero
	/// size of image
	fileprivate var imgF = CGRect.zero
	/// layout type
	open var layoutType = LayoutType.normal {
		didSet { self.setNeedsLayout() }
	}
	/// border line width
	open var borderWidth = 0.0 {
		didSet {
			self.setNeedsDisplay()
		}
	}
	/// border line color
	open var borderColor = UIColor.black {
		didSet { self.setNeedsDisplay() }
	}
	/// fill color
	open var fillColor = UIColor.clear {
		didSet { self.setNeedsDisplay() }
	}

	// MARK: computed property

	/// animation images
	open var animationImages: [UIImage]? {
		set {
			self.setImage(newValue?.first, for: UIControlState())
			self.imageView?.animationImages = newValue
		}
		get {
			return self.imageView?.animationImages
		}
	}

	/// animation duration
	open var animationDuration: TimeInterval {
		set {
			self.imageView?.animationDuration = newValue
		}
		get {
			return self.imageView?.animationDuration ?? 0
		}
	}

	/// animation repeat count
	open var animationRepeatCount: Int {
		set {
			self.imageView?.animationRepeatCount = newValue
		}
		get {
			return self.imageView?.animationRepeatCount ?? 0
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	convenience init(layoutType: LayoutType) {
		self.init(frame: CGRect.zero)
		self.layoutType = layoutType
	}

	open override func layoutSubviews() {
		super.layoutSubviews()
		// 1. cal image bounds
		if let img = self.currentImage {
			imgF = CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height)
		}
		// 2. cal title bounds
		if let ttl = self.currentTitle, let font = self.titleLabel?.font {
			ttlF = (ttl as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
			                                              options: NSStringDrawingOptions.usesLineFragmentOrigin,
			                                              attributes: [NSFontAttributeName: font],
			                                              context: nil)
		}
		// 3. layout subviews
		switch layoutType {
		// 3.1
		case .leftTitleRightImage:	// w = 120, h = 60
			// 3.1.1 cal title frame
			// default horizontal margin of title
			let hTtlMrgDef = max((frame.width - imgF.width - ttlF.width) * 0.5, 0.0)
			// default vertical margin of title
			let vTtlMrgDef = max((frame.height - ttlF.height) * 0.5, 0.0)
			// ttlX/Y/W/H
			let ttlX = contentEdgeInsets.left + titleEdgeInsets.left + hTtlMrgDef
			let ttlY = contentEdgeInsets.top + titleEdgeInsets.top + vTtlMrgDef
			let ttlW = max(min(frame.width - ttlX - contentEdgeInsets.right - titleEdgeInsets.right, ttlF.width), 0.0)
			let ttlH = max(min(frame.height - ttlY - contentEdgeInsets.bottom - titleEdgeInsets.bottom, ttlF.height), 0.0)
			let newTtlF = CGRect(x: ttlX, y: ttlY, width: ttlW, height: ttlH)
			// 3.1.2 cal image frame
			// default vertical margin of image
			let vImgMrgDef = (frame.height - imgF.height) * 0.5
			// imgX/Y/W/H
			let imgX = contentEdgeInsets.left + imageEdgeInsets.left + hTtlMrgDef + ttlF.width
			let imgY = contentEdgeInsets.top + imageEdgeInsets.top + vImgMrgDef
			let imgW = max(min(frame.width - imgX - contentEdgeInsets.right - imageEdgeInsets.right, imgF.width), 0.0)
			let imgH = max(min(frame.height - imgY - contentEdgeInsets.bottom - imageEdgeInsets.bottom, imgF.height), 0.0)
			let newImgF = CGRect(x: imgX, y: imgY, width: imgW, height: imgH)
			self.titleLabel?.frame = newTtlF
			self.imageView?.frame = newImgF
//			print("\noverall frame = \(frame)\ntitle frame = \(ttlF)\nimage frame = \(imgF)\ndefault title margin H = \(hTtlMrgDef)\ndefault title margi V = \(vTtlMrgDef)\ntitle frame = \(newTtlF)")
			break
		// 3.2
		case .topImageBottomTitle:
			// 3.2.1 cal image frame
			// default horizontal margin of image
			let hImgMrgDef = max((frame.width - imgF.width) * 0.5, 0.0)
			// default vertical margin of image
			let vImgMrgDef = max((frame.height - imgF.height - ttlF.height) * 0.5, 0.0)
			// imgX/Y/W/H
			let imgX = contentEdgeInsets.left + imageEdgeInsets.left + hImgMrgDef
			let imgY = contentEdgeInsets.top + imageEdgeInsets.top + vImgMrgDef
			let imgW = max(min(frame.width - imgX - contentEdgeInsets.right - imageEdgeInsets.right, imgF.width), 0.0)
			let imgH = max(min(frame.height - imgY - contentEdgeInsets.bottom - imageEdgeInsets.bottom, imgF.height), 0.0)
			let newImgF = CGRect(x: imgX, y: imgY, width: imgW, height: imgH)
			// 3.2.2 cal title frame
			// default horizontal margin of title
			let hTtlMrgDef = max((frame.width - ttlF.width) * 0.5, 0.0)
			// ttlX/Y/W/H
			let ttlX = contentEdgeInsets.left + titleEdgeInsets.left + hTtlMrgDef
			let ttlY = contentEdgeInsets.top + titleEdgeInsets.top + vImgMrgDef + imgF.height
			let ttlW = max(min(frame.width - ttlX - contentEdgeInsets.right - titleEdgeInsets.right, ttlF.width), 0.0)
			let ttlH = max(min(frame.height - ttlY - contentEdgeInsets.bottom - titleEdgeInsets.bottom, ttlF.height), 0.0)
			let newTtlF = CGRect(x: ttlX, y: ttlY, width: ttlW, height: ttlH)
			self.titleLabel?.frame = newTtlF
			self.imageView?.frame = newImgF
			break
		case .topTitleBottomImage:
			// 3.2.1 cal title frame
			// default horizontal margin of title
			let hTtlMrgDef = max((frame.width - ttlF.width) * 0.5, 0.0)
			// default vertical margin of title
			let vTtlMrgDef = max((frame.height - ttlF.height - imgF.height) * 0.5, 0.0)
			// ttlX/Y/W/H
			let ttlX = contentEdgeInsets.left + titleEdgeInsets.left + hTtlMrgDef
			let ttlY = contentEdgeInsets.top + titleEdgeInsets.top + vTtlMrgDef
			let ttlW = max(min(frame.width - ttlX - contentEdgeInsets.right - titleEdgeInsets.right, ttlF.width), 0.0)
			let ttlH = max(min(frame.height - ttlY - contentEdgeInsets.bottom - titleEdgeInsets.bottom, ttlF.height), 0.0)
			let newTtlF = CGRect(x: ttlX, y: ttlY, width: ttlW, height: ttlH)
			// 3.2.2 cal image frame
			// default horizontal margin of image
			let hImgMrgDef = max((frame.width - imgF.width) * 0.5, 0.0)
			// imgX/Y/W/H
			let imgX = contentEdgeInsets.left + imageEdgeInsets.left + hImgMrgDef
			let imgY = contentEdgeInsets.top + imageEdgeInsets.top + vTtlMrgDef + ttlF.height
			let imgW = max(min(frame.width - imgX - contentEdgeInsets.right - imageEdgeInsets.right, imgF.width), 0.0)
			let imgH = max(min(frame.height - imgY - contentEdgeInsets.bottom - imageEdgeInsets.bottom, imgF.height), 0.0)
			let newImgF = CGRect(x: imgX, y: imgY, width: imgW, height: imgH)
			self.titleLabel?.frame = newTtlF
			self.imageView?.frame = newImgF
			break
		default:
			break
		}
	}
}

// MARK: -
extension NBButton {

	open override func draw(_ rect: CGRect) {
		super.draw(rect)
		if borderWidth > 0 {
		dog("\(self.layer.cornerRadius)")
			// 1. draw border
			// 1.1 cal rect for border path
			let bW = rect.width - borderWidth.cgFloat
			let bH = rect.height - borderWidth.cgFloat
			let bCR = max(self.layer.cornerRadius - borderWidth.cgFloat * 0.5, 0.0)
			let bX = borderWidth.cgFloat * 0.5
			let bY = bX
			let borderP = UIBezierPath(roundedRect: CGRect(x: bX, y: bY, width: bW, height: bH), cornerRadius: bCR)
			borderP.lineWidth = borderWidth.cgFloat
			borderColor.setStroke()
			borderP.addClip()
			borderP.stroke()
			// 2. fill within border
			let fW = bW - borderWidth.cgFloat
			let fH = bH - borderWidth.cgFloat
			let fX = borderWidth.cgFloat
			let fY = fX
			let fCR = max(self.layer.cornerRadius - borderWidth.cgFloat, 0.0)
			let fP = UIBezierPath(roundedRect: CGRect(x: fX, y: fY, width: fW, height: fH), cornerRadius: fCR)
			self.backgroundColor = UIColor.clear
			fillColor.setFill()
			fP.fill()
		}
	}

	public func startAnimating() {
		self.imageView?.startAnimating()
	}

	public func stopAnimating() {
		self.imageView?.stopAnimating()
	}

	public func isAnimating() -> Bool {
		return self.imageView?.isAnimating ?? false
	}
}
