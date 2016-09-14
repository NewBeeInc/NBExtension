//
//  FocusView.swift
//  Aura
//
//  Created by Ke Yang on 3/14/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import UIKit

// MARK: - 私有常量

// MARK: - 代理协议

// MARK: - [控件]<#描述#>

/// <#描述#>
open class FocusView: UIControl {

	// MARK: 控件属性

	/**
	*  8.x 以上系统使用雾面玻璃效果
	*/
	@available(iOS 8.0, *)
	lazy var blurView: UIVisualEffectView = {
		let blurView = UIVisualEffectView(effect: nil)
		blurView.alpha = 0.7
		self.insertSubview(blurView, at: 0)
		return blurView
	}()

	// MARK: 储值属性

	// MARK: 计算属性

	// MARK: 构造方法

	// MARK: 排布子控件

	@available(*, unavailable, message: "don't call this method directly")
	override open func layoutSubviews() {
		super.layoutSubviews()

	}

    /*
	// MARK: 绘图方法

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
	@available(*, unavailable, message="don't call this method directly")
    override public func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

	// MARK: 其他

	// MARK: 销毁

	deinit {

	}

}

// MARK: - 开放接口

public extension FocusView {

}

// MARK: - 私有方法

private extension FocusView {

}

// MARK: - 代理方法

//extension FocusView: <#代理协议#> {
//
//}
