//
//  keyOfVv+GCD.swift
//  Aura
//
//  Created by keyOfVv on 10/19/15.
//  Copyright © 2015 com.sangebaba. All rights reserved.
//

import Foundation

// MARK: - GCD全局队列快速构造方法

/// 全局主队列
public var GLOBAL_MAIN_QUEUE: DispatchQueue {
	return DispatchQueue.main
}

/// GLOBAL_USER_INTERACTIVE_QUEUE
/// GLOBAL_USER_INTERACTIVE_QUEUE
public var GLOBAL_USER_INTERACTIVE_QUEUE: DispatchQueue {
	if #available(iOS 8.0, *) {
		return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
	} else {
		return DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
	}
}

/// GLOBAL_USER_INITIATED_QUEUE
public var GLOBAL_USER_INITIATED_QUEUE: DispatchQueue {
	if #available(iOS 8.0, *) {
		return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
	} else {
		return DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
	}
}

/// GLOBAL_UTILITY_QUEUE
public var GLOBAL_UTILITY_QUEUE: DispatchQueue {
	if #available(iOS 8.0, *) {
		return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
	} else {
		return DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.low)
	}
}

/// GLOBAL_BACKGROUND_QUEUE
public var GLOBAL_BACKGROUND_QUEUE: DispatchQueue {
	if #available(iOS 8.0, *) {
		return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
	} else {
		return DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background)
	}
}

/**
延迟执行闭包

- parameter delay:   延迟时长
- parameter closure: 闭包
*/
public func delay(_ delay:Double, closure:@escaping ()->()) {
	DispatchQueue.main.asyncAfter(
		deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
		execute: closure
	)
}
