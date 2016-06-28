//
//  ZBarPickerOverlayView.swift
//  customZbarInterface
//
//  Created by Ke Yang on 6/22/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import UIKit

class ZBarPickerOverlayView: UIView {

	private lazy var frameImgView: UIImageView = {
		let imgView = UIImageView(frame: CGRectZero)
		if let imgPath = NSBundle.mainBundle().pathForResource("zbarFrame", ofType: ".png") {
			let img = UIImage(contentsOfFile: imgPath)
			imgView.image = img
		}
		self.addSubview(imgView)
		return imgView
	}()

	private lazy var scannerLineImgView: UIImageView = {
		let imgView = UIImageView(frame: CGRectZero)
		if let imgPath = NSBundle.mainBundle().pathForResource("scanner", ofType: ".jpg") {
			let img = UIImage(contentsOfFile: imgPath)
			imgView.image = img
		}
		self.addSubview(imgView)
		return imgView
	}()

	var timer: NSTimer?
	var animDuration = 3.0

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.clearColor()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

    override func drawRect(rect: CGRect) {
		// 上部矩形+下部"凹"形
		let irw = rect.width * 0.6
		let irh = irw

		let otl = CGPointZero
		let otr = CGPointMake(rect.width, 0.0)
		let olr = CGPointMake(rect.width, rect.height)
		let oll = CGPointMake(0.0, rect.height)

		let lta = CGPointMake(0.0, (rect.height - irh) * 0.5)
		let rta = CGPointMake(rect.width, lta.y)

		let trim = 0.1.cgFloat

		let lba = CGPointMake(lta.x, lta.y - trim)
		let rba = CGPointMake(rta.x, rta.y - trim)

		let itl = CGPointMake((rect.width - irw) * 0.5 , (rect.height - irh) * 0.5 - trim)
		let itr = CGPointMake(itl.x + irw, itl.y)
		let ilr = CGPointMake(itr.x, itr.y + irh)
		let ill = CGPointMake(itl.x, ilr.y)


		let tp = UIBezierPath()
		tp.moveToPoint(otl)
		tp.addLineToPoint(otr)
		tp.addLineToPoint(rta)
		tp.addLineToPoint(lta)
		tp.closePath()
		tp.lineWidth = 0.0
		UIColor(white: 0.0, alpha: 0.8).setFill()
		tp.fill()

		let bp = UIBezierPath()
		bp.moveToPoint(lba)
		bp.addLineToPoint(itl)
		bp.addLineToPoint(ill)
		bp.addLineToPoint(ilr)
		bp.addLineToPoint(itr)
		bp.addLineToPoint(rba)
		bp.addLineToPoint(olr)
		bp.addLineToPoint(oll)
		bp.closePath()
		bp.lineWidth = 0.0
		bp.fill()
    }

	override func layoutSubviews() {
		super.layoutSubviews()
		self.frameImgView.width = self.width * 0.6
		self.frameImgView.height = self.frameImgView.width
		self.frameImgView.x = (self.width - self.frameImgView.width) * 0.5
		self.frameImgView.y = (self.height - self.frameImgView.height) * 0.5

		self.scannerLineImgView.width = self.frameImgView.width - 6.0
		self.scannerLineImgView.height = 2.0
		self.scannerLineImgView.centerX = self.width * 0.5
		self.scannerLineImgView.y = self.frameImgView.y
	}

	func playScanAnim() {
		if self.timer == nil {
			self.timer = NSTimer.scheduledTimerWithTimeInterval(animDuration, target: self, selector: #selector(self.playScanAnim), userInfo: nil, repeats: true)
		}
		UIView.animateWithDuration(self.animDuration * 0.5, animations: {
			self.scannerLineImgView.maxY = self.frameImgView.maxY
		}) { (finished) in
			if finished {
				UIView.animateWithDuration(self.animDuration * 0.5) {
					self.scannerLineImgView.y = self.frameImgView.y
				}
			}
		}
	}

	func stopScanAnim() {
		self.timer = nil
	}
}
