//
//  ZBarPickerOverlayView.swift
//  customZbarInterface
//
//  Created by Ke Yang on 6/22/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import UIKit
import KEYExtension

class ZBarPickerOverlayView: UIView {

	fileprivate lazy var frameImgView: UIImageView = {
		let imgView = UIImageView(frame: CGRect.zero)
		if let imgPath = Bundle.main.path(forResource: "zbarFrame", ofType: ".png") {
			let img = UIImage(contentsOfFile: imgPath)
			imgView.image = img
		}
		self.addSubview(imgView)
		return imgView
	}()

	fileprivate lazy var scannerLineImgView: UIImageView = {
		let imgView = UIImageView(frame: CGRect.zero)
		if let imgPath = Bundle.main.path(forResource: "scanner", ofType: ".jpg") {
			let img = UIImage(contentsOfFile: imgPath)
			imgView.image = img
		}
		self.addSubview(imgView)
		return imgView
	}()

	var timer: Timer?
	var animDuration = 3.0

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.clear
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

    override func draw(_ rect: CGRect) {
		// 上部矩形+下部"凹"形
		let irw = rect.width * 0.6
		let irh = irw

		let otl = CGPoint.zero
		let otr = CGPoint(x: rect.width, y: 0.0)
		let olr = CGPoint(x: rect.width, y: rect.height)
		let oll = CGPoint(x: 0.0, y: rect.height)

		let lta = CGPoint(x: 0.0, y: (rect.height - irh) * 0.5)
		let rta = CGPoint(x: rect.width, y: lta.y)

		let trim = 0.1.cgFloat

		let lba = CGPoint(x: lta.x, y: lta.y - trim)
		let rba = CGPoint(x: rta.x, y: rta.y - trim)

		let itl = CGPoint(x: (rect.width - irw) * 0.5 , y: (rect.height - irh) * 0.5 - trim)
		let itr = CGPoint(x: itl.x + irw, y: itl.y)
		let ilr = CGPoint(x: itr.x, y: itr.y + irh)
		let ill = CGPoint(x: itl.x, y: ilr.y)


		let tp = UIBezierPath()
		tp.move(to: otl)
		tp.addLine(to: otr)
		tp.addLine(to: rta)
		tp.addLine(to: lta)
		tp.close()
		tp.lineWidth = 0.0
		UIColor(white: 0.0, alpha: 0.8).setFill()
		tp.fill()

		let bp = UIBezierPath()
		bp.move(to: lba)
		bp.addLine(to: itl)
		bp.addLine(to: ill)
		bp.addLine(to: ilr)
		bp.addLine(to: itr)
		bp.addLine(to: rba)
		bp.addLine(to: olr)
		bp.addLine(to: oll)
		bp.close()
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
			self.timer = Timer.scheduledTimer(timeInterval: animDuration, target: self, selector: #selector(self.playScanAnim), userInfo: nil, repeats: true)
		}
		UIView.animate(withDuration: self.animDuration * 0.5, animations: {
			self.scannerLineImgView.maxY = self.frameImgView.maxY
		}, completion: { (finished) in
			if finished {
				UIView.animate(withDuration: self.animDuration * 0.5, animations: {
					self.scannerLineImgView.y = self.frameImgView.y
				}) 
			}
		}) 
	}

	func stopScanAnim() {
		self.timer = nil
	}
}
