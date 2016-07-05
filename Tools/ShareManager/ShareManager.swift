//
//  ShareManager.swift
//  Aura
//
//  Created by keyOfVv on 11/23/15.
//  Copyright © 2015 com.sangebaba. All rights reserved.
//

import UIKit

// MARK: - [工具类]第三方平台分享工具

/// 负责分享特定的内容至第三方平台(微信, 朋友圈, 微博)
public class ShareManager: NSObject {

	/// 单例对象
	public class var manager: ShareManager {
		struct Static {
			static let instance: ShareManager = ShareManager()
		}
		return Static.instance
	}

	var supportsWechat = false
	var supportsWeibo = false
}

public extension ShareManager {

	/**
	设置WeChatSDK的App ID

	- parameter id: App ID字符串
	*/
	public func regWeChatAppId(id: String) {
		WXApi.registerApp(id)
	}
}

// MARK: - 开放方法

public extension ShareManager {

	/**
	分享链接到微信聊天/朋友圈

	- parameter url:     链接
	- parameter title:   标题
	- parameter content: 内容
	- parameter icon:    图标
	- parameter channel: 微信内渠道
	*/
	public func sharingToWeChatCommon(url: String?, title: String?, content: String?, icon: UIImage?, channel: WeChatChannel) {
		if WXApi.isWXAppInstalled() {
			// 分享
			let message = WXMediaMessage()

			switch channel {
			case .WeChatSession:
                message.title       = ""
                message.description = title
				break
			case .WeChatTimeLine:
                message.title       = ""
                message.description = title
				break
			}
			let webMessage = WXWebpageObject()
			webMessage.webpageUrl = url

			message.mediaObject = webMessage
			message.setThumbImage(icon)

            let req     = SendMessageToWXReq()
            req.bText   = false
            req.message = message
            req.scene   = Int32(channel.rawValue)
			WXApi.sendReq(req)

		} else {
			// 未安装微信
			MBProgressHUD.showError("您未安装微信哦...")
		}
	}

	/**
	分享图片到微信聊天/朋友圈

	- parameter icon:    缩略图
	- parameter image:   图片
	- parameter title:   标题
	- parameter content: 内容
	- parameter channel: 微信内渠道
	*/
	public func sharingToWeChatCommon(icon: UIImage?, image: UIImage?, title: String?, content: String?, channel: WeChatChannel) {
		if WXApi.isWXAppInstalled() {
			// 分享
			let message         = WXMediaMessage()
			message.title       = title
			message.description = content

			let imageObject = WXImageObject()
			if let image = image {
				if let imageData = UIImageJPEGRepresentation(image, 0.5) {
				dog("\(imageData.length)")
					imageObject.imageData = imageData
				}

				if let thumbImg = icon {
					message.setThumbImage(UIImage(data: UIImageJPEGRepresentation(thumbImg.imageScaledBy(0.25), 0.15)!))
				}
			}

			message.mediaObject = imageObject

			let req     = SendMessageToWXReq()
			req.bText   = false
			req.message = message
			req.scene   = Int32(channel.rawValue)
			WXApi.sendReq(req)
		} else {
			// 未安装微信
			MBProgressHUD.showError("您未安装微信哦...")
		}
	}


	/**
	分享链接+图片到微博

	- parameter url:   链接
	- parameter title: 标题
	- parameter icon:  图标
	- parameter image: 图片
	*/
	/*public func sharingToWeibo(url: String?, title: String?, icon: UIImage?, image: UIImage?) {
		let messageObject = WBMessageObject.message() as! WBMessageObject
		messageObject.text = ((title == nil) ? "" : title!) + ((url == nil) ? "" : url!)
		if let image = image {
            let imageObject           = WBImageObject.object() as! WBImageObject
            imageObject.imageData     = UIImageJPEGRepresentation(image, 0.3.cgFloat)
            messageObject.imageObject = imageObject

		}
		let request = WBSendMessageToWeiboRequest.requestWithMessage(messageObject) as! WBSendMessageToWeiboRequest
		WeiboSDK.sendRequest(request)
	}*/

}

// MARK: - 分享漏斗统计相关的枚举类型

public extension ShareManager {

	/**
	分享形式

	- QRCode: 二维码
	- URL:    链接
	*/
	public enum Form: String {
		/// 二维码
		case QRCode = "CF_QRCSB_"
		/// 链接
		case URL	= "CF_URLSB_"
	}

	/**
	分享平台

	- WeChatSession:  微信聊天
	- WeChatTimeLine: 朋友圈
	- Weibo:          微博
	*/
	public enum Platform: String {
		/// 微信聊天
        case WeChatSession  = "WXS_"
		/// 朋友圈
        case WeChatTimeLine = "WXT_"
		/// 微博
        case Weibo          = "WB_"
	}

	/**
	微信内的不同渠道

	- WeChatSession:  微信聊天
	- WeChatTimeLine: 朋友圈
	*/
	@objc public enum WeChatChannel: Int {
		/// 微信聊天
		case WeChatSession
		/// 朋友圈
		case WeChatTimeLine
	}

}


