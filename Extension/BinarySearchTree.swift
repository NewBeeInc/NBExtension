//
//  BinarySearchTree.swift
//  Aura
//
//  Created by Ke Yang on 3/6/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import Foundation

public class BinarySearchTree<T: Comparable> {
	private(set) public var value: T
	private(set) public var parent: BinarySearchTree?
	private(set) public var left: BinarySearchTree?
	private(set) public var right: BinarySearchTree?

	public init(value: T) {
		self.value = value
	}

	public var isRoot: Bool {
		return parent == nil
	}

	public var isLeaf: Bool {
		return left == nil && right == nil
	}

	public var isLeftChild: Bool {
		return parent?.left === self
	}

	public var isRightChild: Bool {
		return parent?.right === self
	}

	public var hasLeftChild: Bool {
		return left != nil
	}

	public var hasRightChild: Bool {
		return right != nil
	}

	public var hasAnyChild: Bool {
		return hasLeftChild || hasRightChild
	}

	public var hasBothChildren: Bool {
		return hasLeftChild && hasRightChild
	}

	public var count: Int {
		return (left?.count ?? 0) + 1 + (right?.count ?? 0)
	}
}

// MARK: - Convenient Initializer
extension BinarySearchTree {

	public convenience init(array: [T]) {
		precondition(array.count > 0)
		self.init(value: array.first!)
		for v in array.dropFirst() {
			insert(v, parent: self)
		}
	}
}

// MARK: - CustomStringConvertible
extension BinarySearchTree: CustomStringConvertible {

	public var description: String {
		var s = ""
		if let left = left {
			s += "(\(left.description)) <- "
		}
		s += "\(value)"
		if let right = right {
			s += " -> (\(right.description))"
		}
		return s
	}
}

// MARK: - Insertion
extension BinarySearchTree {

	public func insert(value: T) {
		insert(value, parent: self)
	}

	private func insert(value: T, parent: BinarySearchTree) {
		if value < self.value {
			if let left = left {
				left.insert(value, parent: left)
			} else {
				left = BinarySearchTree(value: value)
				left?.parent = parent
			}
		} else {
			if let right = right {
				right.insert(value, parent: right)
			} else {
				right = BinarySearchTree(value: value)
				right?.parent = parent
			}
		}
	}
}

// MARK: - Search
extension BinarySearchTree {

	public func search(value: T) -> BinarySearchTree? {
		var node: BinarySearchTree? = self
		while case let n? = node {
			if value < n.value {
				node = n.left
			} else if value > n.value {
				node = n.right
			} else {
				return node
			}
		}
		return nil
	}
}

// MARK: - Traversal
extension BinarySearchTree {

	public func traverseInOrder(@noescape process: T -> Void) {
		left?.traverseInOrder(process)
		process(value)
		right?.traverseInOrder(process)
	}

	public func traversePreOrder(@noescape process: T -> Void) {
		process(value)
		left?.traversePreOrder(process)
		right?.traversePreOrder(process)
	}

	public func traversePostOrder(@noescape process: T -> Void) {
		left?.traversePostOrder(process)
		right?.traversePostOrder(process)
		process(value)
	}
}

// MARK: - Map
extension BinarySearchTree {

	public func map(@noescape formula: T -> T) -> [T] {
		var a = [T]()
		if let left = left {
			a += left.map(formula)
		}
		a.append(formula(value))
		if let right = right {
			a += right.map(formula)
		}
		return a
	}

	public func toArray() -> [T] {
		return map { $0 }
	}
}

// MARK: - Deleting nodes
extension BinarySearchTree {

	private func reconnectParentToNode(node: BinarySearchTree?) {
		if let parent = parent {
			if isLeftChild {
				parent.left = node
			} else {
				parent.right = node
			}
		}
		node?.parent = parent
	}

	public func minimum() -> BinarySearchTree {
		var node = self
		while case let next? = node.left {
			node = next
		}
		return node
	}

	public func maximum() -> BinarySearchTree {
		var node = self
		while case let next? = node.right {
			node = next
		}
		return node
	}

	public func remove() {
		if let left = left {
			if let right = right {
				let successor = right.minimum()
				value = successor.value
				successor.remove()
			} else {
				reconnectParentToNode(left)
			}
		} else if let right = right {
			reconnectParentToNode(right)
		} else {
			reconnectParentToNode(nil)
		}
	}
}

// MARK: - Depth & height
extension BinarySearchTree {

	public func height() -> Int {
		if isLeaf {
			return 0
		} else {
			return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
		}
	}

	public func depth() -> Int {
		var node = self
		var edges = 0
		while case let parent? = node.parent {
			node = parent
			edges += 1
		}
		return edges
	}
}

// MARK: - Predecessor & successor
extension BinarySearchTree {

	public func predecessor() -> BinarySearchTree<T>? {
		if let left = left {
			return left.maximum()
		} else {
			var node = self
			while case let parent? = node.parent {
				if parent.value < value { return parent }
				node = parent
			}
			return nil
		}
	}

	public func successor() -> BinarySearchTree<T>? {
		if let right = right {
			return right.minimum()
		} else {
			var node = self
			while case let parent? = node.parent {
				if parent.value > value { return parent }
				node = parent
			}
			return nil
		}
	}
}

// MARK: - Verification
extension BinarySearchTree {

	public func isBST(minValue minValue: T, maxValue: T) -> Bool {
		if value < minValue || value > maxValue { return false }
		let leftBST = left?.isBST(minValue: minValue, maxValue: value) ?? true
		let rightBST = right?.isBST(minValue: value, maxValue: maxValue) ?? true
		return leftBST && rightBST
	}
}


