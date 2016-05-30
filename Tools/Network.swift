//
//  Network.swift
//  Campusensor
//
//  Created by Ke Yang on 5/30/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import UIKit

class Network: NSObject {

	/// 单例对象
	class var manager: Network {
		struct Static {
			static let instance: Network = Network()
		}
		return Static.instance
	}

	// MARK: 核心请求方法

//	func get(URL: String, parameters: Dictionary<String, AnyObject>) {
//		request(Method.GET,
//		        URL,
//		        parameters: parameters,
//		        encoding: ParameterEncoding.JSON,
//		        headers: nil)
//	}
}
