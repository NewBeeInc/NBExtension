//
//  FoundationExtension.swift
//  Aura
//
//  Created by Ke Yang on 3/4/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import UIKit

public struct Stack<T> {
	fileprivate var array = [T]()

	public var isEmpty: Bool {
		return array.isEmpty
	}

	public var count: Int {
		return array.count
	}

	public mutating func push(_ element: T) {
		array.append(element)
	}

	public mutating func pop() -> T? {
		if isEmpty {
			return nil
		} else {
			return array.removeLast()
		}
	}

	public func peek() -> T? {
		return array.last
	}
}

public struct Queue<T> {
	fileprivate var array = [T?]()
	fileprivate var head = 0

	public var isEmpty: Bool {
		return array.isEmpty
	}

	public var count: Int {
		return array.count - head
	}

	public mutating func enqueue(_ element: T) {
		array.append(element)
	}

	public mutating func dequeue() -> T?  {
		guard head < array.count, let element = array[head] else { return nil }

		array[head] = nil
		head += 1

		let percentage = Double(head)/Double(array.count)
		if head > 20 && percentage > 0.25 {
			array.removeFirst(head)
			head = 0
		}

		return element
	}

	public func peek() -> T? {
		if isEmpty {
			return nil
		} else {
			return array[head]
		}
	}
}
