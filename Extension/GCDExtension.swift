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
public var GLOBAL_MAIN_QUEUE: dispatch_queue_t {
	return dispatch_get_main_queue()
}

/// GLOBAL_USER_INTERACTIVE_QUEUE
public var GLOBAL_USER_INTERACTIVE_QUEUE: dispatch_queue_t {
	if #available(iOS 8.0, *) {
	    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
	} else {
	    return dispatch_get_global_queue(Int(DISPATCH_QUEUE_PRIORITY_HIGH), 0)
	}
}

/// GLOBAL_USER_INITIATED_QUEUE
public var GLOBAL_USER_INITIATED_QUEUE: dispatch_queue_t {
	if #available(iOS 8.0, *) {
	    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
	} else {
		return dispatch_get_global_queue(Int(DISPATCH_QUEUE_PRIORITY_HIGH), 0)
	}
}

/// GLOBAL_UTILITY_QUEUE
public var GLOBAL_UTILITY_QUEUE: dispatch_queue_t {
	if #available(iOS 8.0, *) {
	    return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.rawValue), 0)
	} else {
		return dispatch_get_global_queue(Int(DISPATCH_QUEUE_PRIORITY_LOW), 0)
	}
}

/// GLOBAL_BACKGROUND_QUEUE
public var GLOBAL_BACKGROUND_QUEUE: dispatch_queue_t {
	if #available(iOS 8.0, *) {
	    return dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)
	} else {
		return dispatch_get_global_queue(Int(DISPATCH_QUEUE_PRIORITY_BACKGROUND), 0)
	}
}

/**
延迟执行闭包

- parameter delay:   延迟时长
- parameter closure: 闭包
*/
public func delay(delay:Double, closure:()->()) {
	dispatch_after(
		dispatch_time(
			DISPATCH_TIME_NOW,
			Int64(delay * Double(NSEC_PER_SEC))
		),
		dispatch_get_main_queue(),
		closure
	)
}
