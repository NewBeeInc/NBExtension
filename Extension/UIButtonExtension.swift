//
//  UIButtonExtension.swift
//  Aura
//
//  Created by Ru.zhang on 16/2/29.
//  Copyright © 2016年 com.sangebaba. All rights reserved.
//

import UIKit

extension UIButton {
    
    func sizeToFitWithInsets(_ insets: UIEdgeInsets) {
        // 计算宽度
        let imgW = (self.imageView?.image == nil ? 0.0 : (self.imageView!.image!.width / SCREEN_SCALE))
        let ttlW = (self.titleLabel?.text == nil ? 0.0 : self.titleLabel!.text!.boundingRectWith(CGSIZE_MAX, font: self.titleLabel?.font).width)
        let padding = self.imageEdgeInsets.right + self.titleEdgeInsets.left
        let leftInset = insets.left
        let rightInset = insets.right
        self.width = leftInset + imgW + padding + ttlW + rightInset
        
        // 计算高度
        let imgH = (self.imageView?.image == nil ? 0.0 : (self.imageView!.image!.height / SCREEN_SCALE))
        let ttlH = (self.titleLabel?.text == nil ? 0.0 : self.titleLabel!.text!.boundingRectWith(CGSIZE_MAX, font: self.titleLabel?.font).height)
        let topInset = insets.top
        let bottomInset = insets.bottom
        self.height = topInset + max(imgH, ttlH) + bottomInset
    }
}
