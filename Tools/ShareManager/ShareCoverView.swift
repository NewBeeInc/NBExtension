//
//  ShareCoverView.swift
//  Aura
//
//  Created by keyOfVv on 12/23/15.
//  Copyright © 2015 com.sangebaba. All rights reserved.
//

import UIKit

// MARK: - Constans

private let leftMargin = 8.0.cgFloat
private let topMargin = 8.0.cgFloat
private let labelSideInset = 7.0.cgFloat

// MARK: - Class definition

class ShareCoverView: UIView {

	// MARK: Interface Elements

	/// 红包图片
	lazy var luckyMoneyImageView: UIImageView = {
		let imageView = UIImageView(frame: CGRectZero)
		imageView.image = UIImage(named: "redbag")
		self.addSubview(imageView)
		return imageView
	}()

	/// 红包文本
	lazy var luckyMoneyLabel: UILabel = {
		let label = UILabel(frame: CGRectZero)
		label.font = FONT_CONTENT
		label.textAlignment = .Center
		label.backgroundColor = COLOR_THEME_YELLOW
		label.layer.cornerRadius = CORNER_RADIUS_UNIVERSAL
		label.layer.masksToBounds = true
		self.addSubview(label)
		self.sendSubviewToBack(label)
		return label
	}()

	lazy var readingView: ReadingView = {
		let view = ReadingView(readings: 0.0, type: ReadingType.PM2_5)
		self.addSubview(view)
		return view
	}()
/*
	/// PM2.5标题
	lazy var pm25TitleLabel: UILabel = {
		let label = UILabel(frame: CGRectZero)
		label.text = "PM 2.5"
		label.font = FONT_PM25_TITLE
		label.textAlignment = .Center
		label.textColor = UIColor.whiteColor()
		label.configShadow(opacity: 1.0, offsetX: 2.0, offsetY: 2.0, radius: 1.0)
		self.addSubview(label)
		return label
	}()

	/// PM2.5数值
	lazy var pm25ValueLabel: UILabel = {
		let label = UILabel(frame: CGRectZero)
		label.font = FONT_PM25
		label.textAlignment = .Center
		label.textColor = UIColor.whiteColor()
		label.configShadow(opacity: 1.0, offsetX: 2.0, offsetY: 2.0, radius: 1.0)
		self.addSubview(label)
		return label
	}()

	/// PM2.5描述
	lazy var pm25DescriptionLabel: UILabel = {
		let label = UILabel(frame: CGRectZero)
		label.font = FONT_PM25_TITLE
		label.textAlignment = .Center
		label.textColor = UIColor.whiteColor()
		label.configShadow(opacity: 1.0, offsetX: 2.0, offsetY: 2.0, radius: 1.0)
		self.addSubview(label)
		return label
	}()
*/
	/// 地址栏背景
	lazy var addressContainerView: UIView = {
		let view = UIView(frame: CGRectZero)
		view.backgroundColor = UIColor(white: CGFloat(0.0), alpha: CGFloat(0.35))
		view.layer.cornerRadius = CORNER_RADIUS_UNIVERSAL
		view.layer.masksToBounds = true
		self.addSubview(view)
		return view
	}()

	/// 地址图片
	lazy var locationImageView: UIImageView = {
		let imageView = UIImageView(frame: CGRectZero)
		imageView.image = UIImage(named: "address")
		imageView.contentMode = .Center
		self.addressContainerView.addSubview(imageView)
		return imageView
	}()

	/// 地址文本
	lazy var addressLabel: UILabel = {
		let label = UILabel(frame: CGRectZero)
		label.font = FONT_CONTENT
		label.numberOfLines = 0
		label.textColor = UIColor.whiteColor()
		label.textAlignment = .Left
		self.addressContainerView.addSubview(label)
		return label
	}()

	/// 底部栏背景
	lazy var bottomContainerView: UIView = {
		let view = UIView(frame: CGRectZero)
		view.backgroundColor = UIColor(white: CGFloat(0.0), alpha: CGFloat(0.35))
		self.addSubview(view)
		return view
	}()

	/// 日期文本
	lazy var dateLabel: UILabel = {
		let label = UILabel(frame: CGRectZero)
		let dateFormat = NSDateFormatter()
		dateFormat.dateFormat =  "yyyy-MM-dd HH:mm:ss"
		let text = dateFormat.stringFromDate(NSDate())
		label.text = text
		label.font = FONT_CONTENT
		label.textColor = UIColor.whiteColor()
		label.textAlignment = .Left
		self.bottomContainerView.addSubview(label)
		return label
	}()

	/// 数据来源文本
	lazy var sourceLabel: UILabel = {
		let label = UILabel(frame: CGRectZero)
		label.text = "实测自 随身PM2.5检测器"
		label.font = FONT_CONTENT
		label.textAlignment = .Right
		label.textColor = UIColor.whiteColor()
		self.bottomContainerView.addSubview(label)
		return label
	}()

	// MARK: Stored Properties

	/// 红包金额
	var dueAmountOfLuckyMoney: Double? {
		didSet {
			if let amount = dueAmountOfLuckyMoney {
				self.luckyMoneyLabel.text = "本次检测将获红包\(amount)元"
			} else {
				self.luckyMoneyLabel.text = nil
			}
		}
	}
	/// PM2.5数值
	var pm25Value: Int? {
		didSet {
			self.readingView.readings = pm25Value?.double ?? 0.0
			/*if let value = pm25Value {
				self.pm25ValueLabel.text = "\(value)"
				self.pm25DescriptionLabel.text = descriptionOfPM25(value)
			} else {
				self.pm25ValueLabel.text = nil
				self.pm25DescriptionLabel.text = nil
			}*/
		}
	}
	/// 地址
//	var address: String? {
//		didSet {
//			if let text = address {
//				self.addressLabel.text = text
//			} else {
//				self.addressLabel.text = nil
//			}
//		}
//	}
	/// 商户信息
	var siteInfo: String? {
		didSet {
			if let text = siteInfo {
				self.addressLabel.text = text
			} else {
				self.addressLabel.text = nil
			}
		}
	}

	// MARK: Initializer

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.clearColor()
	}

	required init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)

	}

	override func layoutSubviews() {
		super.layoutSubviews()

		// 设置右上角的红包
		if self.dueAmountOfLuckyMoney > 0.0 {
            self.luckyMoneyImageView.width  = 30.0
            self.luckyMoneyImageView.height = 35.0
            self.luckyMoneyImageView.x      = leftMargin
            self.luckyMoneyImageView.y      = topMargin

			if let size = self.luckyMoneyLabel.text?.boundingRectWith(CGSIZE_MAX, font: self.luckyMoneyLabel.font) {
				let width = size.width + labelSideInset * 2.0

                self.luckyMoneyLabel.width  = width
                self.luckyMoneyLabel.height = 20.0.cgFloat
                self.luckyMoneyLabel.x      = self.luckyMoneyImageView.maxX - 5.0.cgFloat
                self.luckyMoneyLabel.y      = self.luckyMoneyImageView.y + (self.luckyMoneyImageView.height - self.luckyMoneyLabel.height) * 0.5
			}
		}

		self.readingView.width = self.width * 0.2
		self.readingView.height = self.width * 0.2
		self.readingView.centerX = self.width * 0.5
		self.readingView.centerY = self.width * 0.5

		// 设置PM数值
		/*if let pm25Value = self.pm25Value {
			let size = String(pm25Value).boundingRectWith(CGSIZE_MAX, font: self.pm25ValueLabel.font)
            self.pm25ValueLabel.width        = self.width * 0.5
            self.pm25ValueLabel.height       = size.height + labelSideInset * 2.0
            self.pm25ValueLabel.centerX      = self.width * 0.5
            self.pm25ValueLabel.centerY      = self.height * 0.5

            self.pm25TitleLabel.width        = self.pm25ValueLabel.width
            self.pm25TitleLabel.height       = 30.0
            self.pm25TitleLabel.x            = self.pm25ValueLabel.x
            self.pm25TitleLabel.maxY         = self.pm25ValueLabel.y

            self.pm25DescriptionLabel.width  = self.pm25ValueLabel.width
            self.pm25DescriptionLabel.height = self.pm25TitleLabel.height
            self.pm25DescriptionLabel.x      = self.pm25ValueLabel.x
            self.pm25DescriptionLabel.y      = self.pm25ValueLabel.maxY
		}*/

		// 设置日期和来源
        self.bottomContainerView.width  = self.width
        self.bottomContainerView.height = 30.0
        self.bottomContainerView.x      = 0.0
        self.bottomContainerView.maxY   = self.height

		if let dateSize = self.dateLabel.text?.boundingRectWith(CGSIZE_MAX, font: self.dateLabel.font) {
            self.dateLabel.width  = dateSize.width + labelSideInset * 2.0
            self.dateLabel.height = self.bottomContainerView.height
            self.dateLabel.x      = labelSideInset
            self.dateLabel.y      = 0.0
		}

        self.sourceLabel.width  = self.bottomContainerView.width - self.dateLabel.width - labelSideInset * 2.0
        self.sourceLabel.height = self.bottomContainerView.height
        self.sourceLabel.x      = self.dateLabel.maxX
        self.sourceLabel.y      = 0.0

		// 设置地址
		if let siteInfo = self.siteInfo {
			let widthLimit = self.width - leftMargin * 2.0 - 24.0 - labelSideInset
			let heightLimit = CGFLOAT_MAX
			let size = siteInfo.boundingRectWith(CGSizeMake(widthLimit, heightLimit), font: self.addressLabel.font)
			self.addressContainerView.width = size.width + labelSideInset + 24.0
			self.addressContainerView.height = size.height
			self.addressContainerView.x = leftMargin
			self.addressContainerView.maxY = self.bottomContainerView.y - 10.0.cgFloat

			self.locationImageView.height = self.addressContainerView.height
			self.locationImageView.width = 24.0
			self.locationImageView.x = 0.0
			self.locationImageView.y = 0.0

			self.addressLabel.width = self.addressContainerView.width - self.locationImageView.width - labelSideInset
			self.addressLabel.height = self.addressContainerView.height
			self.addressLabel.x = self.locationImageView.width
			self.addressLabel.y = 0.0
		}
	}
}









