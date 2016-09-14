//
//  NSUserDefaultsExtension.swift
//  Aura
//
//  Created by keyOfVv on 1/8/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import Foundation

// MARK: - Swift中的归档与反归档

public extension UserDefaults {

	//	func setObject(value: AnyObject?, forKey defaultName: String)

	/**
	归档

	- parameter object:      任意对象
	- parameter defaultName: 键
	*/
	public func setSwiftObject(_ object: AnyObject?, forKey defaultName: String) {
		if let unwrappedObject: AnyObject = object {
			let archivedData = NSKeyedArchiver.archivedData(withRootObject: unwrappedObject)
			UserDefaults.standard.set(archivedData, forKey: defaultName)
		}
	}

	//  func objectForKey(defaultName: String) -> AnyObject?

	/**
	反归档

	- parameter defaultName: 键

	- returns: 归档对象, 如不存在则返回nil
	*/
	public func swiftObjectForKey(_ defaultName: String) -> AnyObject? {
		if let unwrappedData = UserDefaults.standard.object(forKey: defaultName) as? Data {
			let keyedUnarchiver = NSKeyedUnarchiver(forReadingWith: unwrappedData)
			let object: AnyObject? = keyedUnarchiver.decodeObject(forKey: "root") as AnyObject?
			return object
		} else {
			return nil
		}
	}
}
