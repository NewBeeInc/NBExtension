//
//  ShareManagerExtension.swift
//  Aura
//
//  Created by Ke Yang on 3/2/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import Foundation
/*
public enum SharingSource {
	case Evaluation
	case Article
}

// MARK: -
extension ShareManager {

	/**
	分享链接到微信聊天/朋友圈

	- parameter url:     链接
	- parameter title:   标题
	- parameter content: 内容
	- parameter icon:    图标
	- parameter channel: 微信内渠道
	*/
	public func sharingToWeChatCommon(url: String?, title: String?, content: String?, icon: UIImage?, channel: WeChatChannel, sharingSource: SharingSource) {
		self.sharingToWeChatCommon(url, title: title, content: content, icon: icon, channel: channel)
		// 记录分享事件
		var behavior: Behavior?

		switch channel {
		case .WeChatSession:
			if sharingSource == .Evaluation {
				// 评测数据分享
				behavior = Behavior.Sharing(ShareManager.Form.URL, ShareManager.Platform.WeChatSession, 0)	// 微信聊天分享URL
			} else if sharingSource == .Article {
				// 文章分享
				if let URL = url {
					// 传入的URL必须是正确的文章URL格式
					if let behaviorInURL = Behavior.behaviorFrom(URL) {
						switch behaviorInURL {
						case .ArticleOperation(let bid, let sys, let e, let c, _, _, _):	// 微信聊天分享文章
							behavior = Behavior.ArticleOperation(bid, sys, e, c, .WeChatSession, .URL, 1)
							break
						default:
							break
						}
					}
				}
			}
			break
		case .WeChatTimeLine:
			if sharingSource == .Evaluation {
				// 评测数据分享
				behavior = Behavior.Sharing(ShareManager.Form.URL, ShareManager.Platform.WeChatTimeLine, 0)// 朋友圈分享URL
			} else if sharingSource == .Article {
				// 文章分享
				if let URL = url {
					// 传入的URL必须是正确的文章URL格式
					if let behaviorInURL = Behavior.behaviorFrom(URL) {
						switch behaviorInURL {
						case .ArticleOperation(let bid, let sys, let e, let c, _, _, _):	// 微信聊天分享文章
							behavior = Behavior.ArticleOperation(bid, sys, e, c, .WeChatTimeLine, .URL, 1)
							break
						default:
							break
						}
					}
				}
			}
			break
		}

		Accountant.defaultAccountant.record(behavior)		// 记录行为
	}

	/**
	分享图片到微信聊天/朋友圈

	- parameter icon:    缩略图
	- parameter image:   图片
	- parameter title:   标题
	- parameter content: 内容
	- parameter channel: 微信内渠道
	*/
	public func sharingToWeChatCommon(icon: UIImage?, image: UIImage?, title: String?, content: String?, channel: WeChatChannel, sharingSource: SharingSource) {
		self.sharingToWeChatCommon(icon, image: image, title: title, content: content, channel: channel)
		// 记录分享事件
		var behavior: Behavior?

		switch channel {
		case .WeChatSession:
			if sharingSource == .Evaluation {
				// 评测数据分享
				behavior = Behavior.Sharing(ShareManager.Form.URL, ShareManager.Platform.WeChatSession, 0)	// 微信聊天分享URL
			} else if sharingSource == .Article {
				// 文章分享
				if let URL = url {
					// 传入的URL必须是正确的文章URL格式
					if let behaviorInURL = Behavior.behaviorFrom(URL) {
						switch behaviorInURL {
						case .ArticleOperation(let bid, let sys, let e, let c, _, _, _):	// 微信聊天分享文章
							behavior = Behavior.ArticleOperation(bid, sys, e, c, .WeChatSession, .URL, 1)
							break
						default:
							break
						}
					}
				}
			}
			break
		case .WeChatTimeLine:
			if sharingSource == .Evaluation {
				// 评测数据分享
				behavior = Behavior.Sharing(ShareManager.Form.URL, ShareManager.Platform.WeChatTimeLine, 0)// 朋友圈分享URL
			} else if sharingSource == .Article {
				// 文章分享
				if let URL = url {
					// 传入的URL必须是正确的文章URL格式
					if let behaviorInURL = Behavior.behaviorFrom(URL) {
						switch behaviorInURL {
						case .ArticleOperation(let bid, let sys, let e, let c, _, _, _):	// 微信聊天分享文章
							behavior = Behavior.ArticleOperation(bid, sys, e, c, .WeChatTimeLine, .URL, 1)
							break
						default:
							break
						}
					}
				}
			}
			break
		}

		Accountant.defaultAccountant.record(behavior)		// 记录行为

	}

	/**
	分享链接+图片到微博

	- parameter url:   链接
	- parameter title: 标题
	- parameter icon:  图标
	- parameter image: 图片
	*/
	public func sharingToWeibo(url: String?, title: String?, icon: UIImage?, image: UIImage?, sharingSource: SharingSource) {
		let messageObject = WBMessageObject.message() as! WBMessageObject
		messageObject.text = ((title == nil) ? "" : title!) + ((url == nil) ? "" : url!)
		if let image = image {
			let imageObject           = WBImageObject.object() as! WBImageObject
			imageObject.imageData     = UIImageJPEGRepresentation(image, 0.3.cgFloat)
			messageObject.imageObject = imageObject

		}
		let request = WBSendMessageToWeiboRequest.requestWithMessage(messageObject) as! WBSendMessageToWeiboRequest
		WeiboSDK.sendRequest(request)

		let behavior = Behavior.Sharing(ShareManager.Form.URL, ShareManager.Platform.Weibo, 0)	// 微信聊天分享二维码
		Accountant.defaultAccountant.record(behavior)		// 记录行为
	}

}
*/