//
//  Network.swift
//  Campusensor
//
//  Created by Ke Yang on 5/30/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import UIKit
import KEYExtension

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
	func checkReachable(_ completion: ((Bool) -> Void)?) {
		delay(0.1) {
			completion?(AFNetworkReachabilityManager.shared().isReachable)
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
	internal func get(URL: String, parameters: [String: AnyObject]!, success: @escaping (_ response: HTTPURLResponse?, _ json: JSON) -> Void, failure: @escaping () -> Void) {

		// 检查网络
		Network.manager.checkReachable { (reachable) in
//			if !reachable {
//				failure()
//				return
//			}

			let manager = AFHTTPRequestOperationManager()
			manager.get(URL, parameters: parameters, success: { (operation, jsonObject) -> Void in
			dog("SUCCESS: \(URL)")
				success(operation?.response, JSON(jsonObject))
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
	internal func post(URL: String, parameters: [String: AnyObject]!, success: @escaping (_ response: HTTPURLResponse?, _ json: JSON) -> Void, failure: @escaping (AFHTTPRequestOperation?) -> Void) {

		// 检查网络
		Network.manager.checkReachable { (reachable) in
//			if !reachable {
//				failure(nil)
//				return
//			}
			let manager = AFHTTPRequestOperationManager()
			manager.post(URL, parameters: parameters, success: { (operation, jsonObject) -> Void in
			dog("SUCCESS: \(URL)")
				success(operation?.response, JSON(jsonObject))
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
	internal func put(URL: String, parameters: [String: AnyObject]!, success: @escaping (_ response: HTTPURLResponse?, _ json: JSON) -> Void, failure: @escaping () -> Void) {

		// 检查网络
		Network.manager.checkReachable { (reachable) in
			if !reachable {
				failure()
				return
			}
			let manager = AFHTTPRequestOperationManager()
			manager.put(URL, parameters: parameters, success: { (operation, jsonObject) -> Void in
			dog("SUCCESS: \(URL)")
				success(operation?.response, JSON(jsonObject))
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
	internal func put(_ URL: String, parameters: [String: AnyObject]!, data: Data?, progress: (Double) -> Void, success: @escaping (Dictionary<String, AnyObject>) -> Void, failure: @escaping () -> Void) {

		// 检查网络
		Network.manager.checkReachable { (reachable) in
			if !reachable {
				failure()
				return
			}

			let serializer = AFHTTPRequestSerializer()
			do {
				let request = try serializer.multipartFormRequest(withMethod: "PUT", urlString: URL, parameters: parameters, constructingBodyWith: { (formData) -> Void in
					if data != nil {
						formData?.appendPart(withFileData: data!, name: "big_image", fileName: "image.jpeg", mimeType: "image/jpeg")
					}
					}, error: ())

				let manager = AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
				var progress: Progress?

				let uploadTask = manager?.uploadTask(withStreamedRequest: request as URLRequest!, progress: &progress) { (response, responseObject, error) -> Void in

					if error != nil {
						failure()
					} else if (response?.isKind(of: HTTPURLResponse.self))! {
						let statusCode = (response as! HTTPURLResponse).statusCode
						if statusCode >= 200 && statusCode < 300 {
							var json = JSON(responseObject)
							success(json.dictionaryObject! as Dictionary<String, AnyObject>)
						} else {
						}
					} else {
						var json = JSON(responseObject)
						success(json.dictionaryObject! as Dictionary<String, AnyObject>)
					}
				}
				
				uploadTask?.resume()
				
			} catch {
				// error occured
			}
		}
	}

}
