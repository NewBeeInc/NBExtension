//
//  SysSingleton.swift
//  Aura
//
//  Created by Ke Yang on 4/18/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 系统单例便捷访问

/// 当前激活的窗口
public let KeyWindow          = UIApplication.shared.keyWindow

/// 通知中心
public let NotificationCenter = Foundation.NotificationCenter.default

/// 主Bundle
public let BUNDLE_MAIN        = Bundle.main

/// 当前设备
public let DEVICE             = UIDevice.current
