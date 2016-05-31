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

	/**
	检查网络是否可用

	- parameter completion: 回调, 返回网络是否可用
	*/
	func checkReachable(completion: ((Bool) -> Void)?) {
		delay(0.1) {
			completion?(AFNetworkReachabilityManager.sharedManager().reachable)
		}
	}

	// MARK: 核心请求方法
	/**
	GET方法封装

	- parameter URL:        接口URL
	- parameter parameters: 参数字典
	- parameter success:    成功回调
	- parameter failure:    失败回调
	*/
	internal func get(URL URL: String, parameters: [String: AnyObject]!, success: (response: NSHTTPURLResponse?, json: JSON) -> Void, failure: () -> Void) {

		// 检查网络
		Network.manager.checkReachable { (reachable) in
			if !reachable {
				failure()
				return
			}

			let manager = AFHTTPRequestOperationManager()
			manager.GET(URL, parameters: parameters, success: { (operation, jsonObject) -> Void in
				log("SUCCESS: \(URL)")
				success(response: operation.response, json: JSON(jsonObject))
				}, failure: { (operation, error) -> Void in
					failure()
			})
		}
	}

	/**
	POST方法封装

	- parameter URL:        接口URL
	- parameter parameters: 参数字典
	- parameter success:    成功回调
	- parameter failure:    失败回调
	*/
	internal func post(URL URL: String, parameters: [String: AnyObject]!, success: (response: NSHTTPURLResponse?, json: JSON) -> Void, failure: (AFHTTPRequestOperation?) -> Void) {

		// 检查网络
		Network.manager.checkReachable { (reachable) in
//			if !reachable {
//				failure(nil)
//				return
//			}
			let manager = AFHTTPRequestOperationManager()
			manager.POST(URL, parameters: parameters, success: { (operation, jsonObject) -> Void in
				log("SUCCESS: \(URL)")
				success(response: operation.response, json: JSON(jsonObject))
				}, failure: { (operation, error) -> Void in
					failure(operation)
			})
		}
	}

	/**
	PUT方法封装

	- parameter URL:        接口URL
	- parameter parameters: 参数字典
	- parameter success:    成功回调
	- parameter failure:    失败回调
	*/
	internal func put(URL URL: String, parameters: [String: AnyObject]!, success: (response: NSHTTPURLResponse?, json: JSON) -> Void, failure: () -> Void) {

		// 检查网络
		Network.manager.checkReachable { (reachable) in
			if !reachable {
				failure()
				return
			}
			let manager = AFHTTPRequestOperationManager()
			manager.PUT(URL, parameters: parameters, success: { (operation, jsonObject) -> Void in
				log("SUCCESS: \(URL)")
				success(response: operation.response, json: JSON(jsonObject))
				}, failure: { (operation, error) -> Void in
					failure()
			})
		}
	}

	/**
	PUT方法封装 - 图片上传

	- parameter URL:        接口URL
	- parameter parameters: 参数字典
	- parameter data:       图片二进制数据
	- parameter progress:   上传进度
	- parameter success:    成功回调
	- parameter failure:    失败回调
	*/
	internal func put(URL: String, parameters: [String: AnyObject]!, data: NSData?, progress: (Double) -> Void, success: (Dictionary<String, AnyObject>) -> Void, failure: () -> Void) {

		// 检查网络
		Network.manager.checkReachable { (reachable) in
			if !reachable {
				failure()
				return
			}

			let serializer = AFHTTPRequestSerializer()
			do {
				let request = try serializer.multipartFormRequestWithMethod("PUT", URLString: URL, parameters: parameters, constructingBodyWithBlock: { (formData) -> Void in
					if data != nil {
						formData.appendPartWithFileData(data!, name: "big_image", fileName: "image.jpeg", mimeType: "image/jpeg")
					}
					}, error: ())

				let manager = AFURLSessionManager(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
				var progress: NSProgress?

				let uploadTask = manager.uploadTaskWithStreamedRequest(request, progress: &progress) { (response, responseObject, error) -> Void in

					if error != nil {
						failure()
					} else if response.isKindOfClass(NSHTTPURLResponse.self) {
						let statusCode = (response as! NSHTTPURLResponse).statusCode
						if statusCode >= 200 && statusCode < 300 {
							var json = JSON(responseObject)
							success(json.dictionaryObject!)
						} else {
						}
					} else {
						var json = JSON(responseObject)
						success(json.dictionaryObject!)
					}
				}
				
				uploadTask.resume()
				
			} catch {
				// error occured
			}
		}
	}

}
