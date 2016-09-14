//
//  NBQRCodeScanViewController.swift
//  xiuxiu
//
//  Created by Ke Yang on 6/28/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import UIKit

@objc public enum NBQRCodeScanViewControllerStyle: Int {
	case fullScreen, custom
}

open class NBQRCodeScanViewController: ZBarReaderViewController {

	fileprivate var style: NBQRCodeScanViewControllerStyle = .fullScreen

	convenience init(style: NBQRCodeScanViewControllerStyle) {
		self.init()
		self.style = style
		self.showsZBarControls = false
		switch style {
		case .fullScreen:
			break
		case .custom:
			self.cameraOverlayView = ZBarPickerOverlayView(frame: UIScreen.main.bounds)
			break
		}
	}

    override open func viewDidLoad() {
        super.viewDidLoad()

    }

	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		switch self.style {
		case .custom:
			(self.cameraOverlayView as! ZBarPickerOverlayView).playScanAnim()
		default:
			break
		}
	}

	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		switch self.style {
		case .custom:
			(self.cameraOverlayView as! ZBarPickerOverlayView).stopScanAnim()
		default:
			break
		}
	}

	open class func extractResult(_ info: [String : AnyObject]) -> String? {
		guard let results = info[ZBarReaderControllerResults] as? ZBarSymbolSet
			else { return nil }
		var symbolFound : ZBarSymbol?
		for symbol in results {
			symbolFound = symbol as? ZBarSymbol
			break
		}
		return symbolFound?.data
	}
}

extension ZBarSymbolSet: Sequence {
	public func makeIterator() -> NSFastEnumerationIterator {
		return NSFastEnumerationIterator(self)
	}
}
