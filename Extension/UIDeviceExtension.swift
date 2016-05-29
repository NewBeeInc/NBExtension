//
//  UIDeviceExtension.swift
//  Aura
//
//  Created by keyOfVv on 1/8/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import Foundation
import UIKit

// MARK: UIDevice
extension UIDevice {
	/*
	public var SSID: String? {
	get {
	if let interfaces = CNCopySupportedInterfaces() {
	let interfacesArray = interfaces.takeRetainedValue() as! [String]
	if let unsafeInterfaceData = CNCopyCurrentNetworkInfo(interfacesArray[0]) {
	let interfaceData = unsafeInterfaceData.takeRetainedValue() as Dictionary
	return interfaceData["SSID"] as? String
	}
	}
	return nil
	}
	} */

	public var iOSVersion: Double {
		get {
			return (self.systemVersion as NSString).doubleValue
		}
	}

}
