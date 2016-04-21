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

@objc public enum LayoutType: Int {
	case Normal
	case LeftTitleRightImage
	case TopTitleBottomImage
	case TopImageBottomTitle
}

class NBButton: UIButton {

	// MARK: stored property

	/// size of title
	private var ttlF = CGRectZero
	/// size of image
	private var imgF = CGRectZero
	/// layout type
	public var layoutType = LayoutType.Normal {
		didSet {
			self.setNeedsLayout()
		}
	}

	// w = 88, h = 30
	// img = 23 * 24.5
	// ttl = 25.5 * 20.5
	// imgX = 19.5, imgW = 23, padding = 0.5, ttlX = 43, ttlW = 25.5
	// 88 - (43 + 25.5) = 19.5

	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	convenience init(layoutType: LayoutType) {
		self.init(frame: CGRectZero)
		self.layoutType = layoutType
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		// 1. cal image bounds
		if let img = self.currentImage {
			imgF = CGRectMake(0.0, 0.0, img.size.width, img.size.height)
		}
		// 2. cal title bounds
		if let ttl = self.currentTitle, font = self.titleLabel?.font {
			ttlF = (ttl as NSString).boundingRectWithSize(CGSizeMake(CGFloat.max, CGFloat.max),
			                                              options: NSStringDrawingOptions.UsesLineFragmentOrigin,
			                                              attributes: [NSFontAttributeName: font],
			                                              context: nil)
		}
		// 3. layout subviews
		switch layoutType {
		// 3.1
		case .LeftTitleRightImage:	// w = 120, h = 60
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
			let newTtlF = CGRectMake(ttlX, ttlY, ttlW, ttlH)
			// 3.1.2 cal image frame
			// default vertical margin of image
			let vImgMrgDef = (frame.height - imgF.height) * 0.5
			// imgX/Y/W/H
			let imgX = contentEdgeInsets.left + imageEdgeInsets.left + hTtlMrgDef + ttlF.width
			let imgY = contentEdgeInsets.top + imageEdgeInsets.top + vImgMrgDef
			let imgW = max(min(frame.width - imgX - contentEdgeInsets.right - imageEdgeInsets.right, imgF.width), 0.0)
			let imgH = max(min(frame.height - imgY - contentEdgeInsets.bottom - imageEdgeInsets.bottom, imgF.height), 0.0)
			let newImgF = CGRectMake(imgX, imgY, imgW, imgH)
			self.titleLabel?.frame = newTtlF
			self.imageView?.frame = newImgF
			print("\noverall frame = \(frame)\ntitle frame = \(ttlF)\nimage frame = \(imgF)\ndefault title margin H = \(hTtlMrgDef)\ndefault title margi V = \(vTtlMrgDef)\ntitle frame = \(newTtlF)")
			break
		// 3.2
		case .TopImageBottomTitle:
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
			let newImgF = CGRectMake(imgX, imgY, imgW, imgH)
			// 3.2.2 cal title frame
			// default horizontal margin of title
			let hTtlMrgDef = max((frame.width - ttlF.width) * 0.5, 0.0)
			// ttlX/Y/W/H
			let ttlX = contentEdgeInsets.left + titleEdgeInsets.left + hTtlMrgDef
			let ttlY = contentEdgeInsets.top + titleEdgeInsets.top + vImgMrgDef + imgF.height
			let ttlW = max(min(frame.width - ttlX - contentEdgeInsets.right - titleEdgeInsets.right, ttlF.width), 0.0)
			let ttlH = max(min(frame.height - ttlY - contentEdgeInsets.bottom - titleEdgeInsets.bottom, ttlF.height), 0.0)
			let newTtlF = CGRectMake(ttlX, ttlY, ttlW, ttlH)
			self.titleLabel?.frame = newTtlF
			self.imageView?.frame = newImgF
			break
		case .TopTitleBottomImage:
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
			let newTtlF = CGRectMake(ttlX, ttlY, ttlW, ttlH)
			// 3.2.2 cal image frame
			// default horizontal margin of image
			let hImgMrgDef = max((frame.width - imgF.width) * 0.5, 0.0)
			// imgX/Y/W/H
			let imgX = contentEdgeInsets.left + imageEdgeInsets.left + hImgMrgDef
			let imgY = contentEdgeInsets.top + imageEdgeInsets.top + vTtlMrgDef + ttlF.height
			let imgW = max(min(frame.width - imgX - contentEdgeInsets.right - imageEdgeInsets.right, imgF.width), 0.0)
			let imgH = max(min(frame.height - imgY - contentEdgeInsets.bottom - imageEdgeInsets.bottom, imgF.height), 0.0)
			let newImgF = CGRectMake(imgX, imgY, imgW, imgH)
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

}
