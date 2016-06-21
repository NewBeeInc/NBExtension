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

	- parameter image:   图片
	- parameter title:   标题
	- parameter content: 内容
	- parameter channel: 微信内渠道
	*/
	@available(*, unavailable, message="use -sharingToWechatCommon(_:image:title:content:channel) instead")
	public func sharingToWeChatCommon(image: UIImage?, title: String?, content: String?, channel: WeChatChannel) {
		if WXApi.isWXAppInstalled() {
			// 分享
            let message         = WXMediaMessage()
            message.title       = title
            message.description = content

			var behavior: Behavior?

			switch channel {
			case .WeChatSession:
				behavior = Behavior.Sharing(ShareManager.Form.QRCode, ShareManager.Platform.WeChatSession, 0)	// 微信聊天分享二维码
				break
			case .WeChatTimeLine:
				behavior = Behavior.Sharing(ShareManager.Form.QRCode, ShareManager.Platform.WeChatTimeLine, 0)	// 朋友圈分享二维码
				break
			}
			Accountant.defaultAccountant.record(behavior)		// 记录行为

			let imageObject = WXImageObject()
			if let image = image {
				if let imageData = UIImageJPEGRepresentation(image, 0.5) {
					log("\(imageData.length)")
					imageObject.imageData = imageData
				}

				message.setThumbImage(UIImage(data: UIImageJPEGRepresentation(image.imageScaledBy(0.25), 0.15)!))
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
					log("\(imageData.length)")
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
	public func sharingToWeibo(url: String?, title: String?, icon: UIImage?, image: UIImage?) {
		let messageObject = WBMessageObject.message() as! WBMessageObject
		messageObject.text = ((title == nil) ? "" : title!) + ((url == nil) ? "" : url!)
		if let image = image {
            let imageObject           = WBImageObject.object() as! WBImageObject
            imageObject.imageData     = UIImageJPEGRepresentation(image, 0.3.cgFloat)
            messageObject.imageObject = imageObject

		}
		let request = WBSendMessageToWeiboRequest.requestWithMessage(messageObject) as! WBSendMessageToWeiboRequest
		WeiboSDK.sendRequest(request)
	}

}

// MARK: - 二维码图片拼接方法

extension ShareManager {

	/**
	拼接二维码分享图片

	- parameter image:      图片
	- parameter qrcodeText: 二维码原始文本
	- parameter amount:     红包金额
	- parameter value:      PM数值
	- parameter siteInfo:   场所信息

	- returns: 返回拼接完成的图片
	*/
	public class func pieceTogetherSharingPicture(image: UIImage?, qrcodeText: String?, luckyMoneyAmount amount: Double?, pm25 value: Int?, siteInfo: String?) -> UIImage? {
		guard let img = image else {
			return nil
		}

		// 图片的宽高比
		let whrOfImg = img.width / img.height
		// 二维码推广图的宽高比
		let whrOfAd = 2.867.cgFloat

		// 0. 设置相框
        let overAllW      = 420.0.cgFloat
        let imgW          = overAllW
        let imgH          = imgW / whrOfImg
        let adW           = overAllW
        let adH           = adW / whrOfAd
        let overAllH      = imgH + adH
        let overallFrame  = CGRectMake(1000.0, 1000.0, overAllW, overAllH)
        let containerView = UIView(frame: overallFrame)

		// 1. 设置图片
        let upperFrame       = CGRectMake(0.0, 0.0, imgW, imgH)
        let photoImageView   = UIImageView(frame: upperFrame)
        photoImageView.image = image
		containerView.addSubview(photoImageView)

		// 2. 设置水印
        let shareCoverView                   = ShareCoverView(frame: upperFrame)
        shareCoverView.dueAmountOfLuckyMoney = amount
        shareCoverView.pm25Value             = value
        shareCoverView.siteInfo              = siteInfo
		containerView.addSubview(shareCoverView)

		// 3. 设置推广图
        let adImageView   = UIImageView(frame: CGRectMake(0.0, imgH, adW, adH))
        adImageView.image = UIImage(named: "share_qrcode_pic")
		containerView.addSubview(adImageView)

		// 3.5 设置二维码图片
		let qrcodeX = adW * 0.785
		let qrcodeY = imgH + 12
		let qrcodeW = adImageView.width * 0.195
		let qrcodeH = qrcodeW
        let qrcodeImageView   = UIImageView(frame: CGRectMake(qrcodeX, qrcodeY, qrcodeW, qrcodeH))
        qrcodeImageView.image = QRCode.generator.imageFor(qrcodeText)
		containerView.addSubview(qrcodeImageView)

		// 4. 准备截图
		KeyWindow?.addSubview(containerView)
		let snapShot = containerView.snapshot()
		containerView.removeFromSuperview()

		return snapShot
	}

	/**
	拼接文章长图+二维码图片

	- parameter image:      文章长图
	- parameter qrcodeText: 二维码文本

	- returns: 拼接
	*/
	public class func pieceTogetherArticleImage(image: UIImage, qrcodeText: String?) -> UIImage? {		// 0.35
		// 0. 设置相框
		let width         = image.size.width
		let height        = image.size.height + width * 0.35
		let overallFrame  = CGRectMake(1000.0, 1000.0, width, height)
		let containerView = UIView(frame: overallFrame)

		// 1. 设置图片
		let upperFrame       = CGRectMake(0.0, 0.0, image.size.width, image.size.height)
		let photoImageView   = UIImageView(frame: upperFrame)
		photoImageView.image = image
		containerView.addSubview(photoImageView)

		// 3. 设置推广图
		let QRView   = UIImageView(frame: CGRectMake(0.0, image.size.height, width, width * 0.35))
		QRView.image = UIImage(named: "share_qrcode_pic")
		containerView.addSubview(QRView)

		// 3.5 设置二维码图片
		let qrcodeX = width * 0.785
		let qrcodeY = image.size.height + 12
		let qrcodeW = QRView.width * 0.195
		let qrcodeH = qrcodeW
		let qrcodeImageView   = UIImageView(frame: CGRectMake(qrcodeX, qrcodeY, qrcodeW, qrcodeH))
		qrcodeImageView.image = QRCode.generator.imageFor(qrcodeText)
		containerView.addSubview(qrcodeImageView)

		// 4. 准备截图
		KeyWindow?.addSubview(containerView)
		let snapShot = containerView.snapshot()
		containerView.removeFromSuperview()

		return snapShot
	}

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
	public enum WeChatChannel: Int {
		/// 微信聊天
		case WeChatSession
		/// 朋友圈
		case WeChatTimeLine
	}

}


