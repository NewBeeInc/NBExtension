//
//  UILabelExtension.swift
//  Aura
//
//  Created by Ke Yang on 3/30/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import UIKit

// MARK: - UILabel
public extension UILabel {

	/**
	根据文本自动调整Label的尺寸, 每次更改Label的相关属性(例如字体)后调用本方法可以更新frame.
	另外, 调用本方法后, 文本自动居中对齐.

	- parameter insets: 距边缘距离
	*/
	public func sizeToFitWithTextSizeLimits(limits: CGSize, andInsets insets: UIEdgeInsets) {
		// -1. 文本居中
		self.textAlignment = .Center
		// 0. 提取各边距
		let t = insets.top, b = insets.bottom, l = insets.left, r = insets.right
		guard let text = self.text else {
			// 如果文本为nil, 则宽度为l+r, 高度为t+b
			self.size = CGSizeMake(l+r, t+b)
			return
		}
		// 1. 计算文本的尺寸
		let rect = text.boundingRectWith(limits, font: self.font)
		let w = rect.width + l + r
		let h = rect.height + t + b
		self.size = CGSizeMake(w, h)
	}
}
