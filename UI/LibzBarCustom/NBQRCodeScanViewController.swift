//
//  NBQRCodeScanViewController.swift
//  xiuxiu
//
//  Created by Ke Yang on 6/28/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import UIKit

public class NBQRCodeScanViewController: ZBarReaderViewController {

	@objc enum Style: Int {
		case FullScreen, Custom
	}

	private var style: Style = .FullScreen

	convenience init(style: Style) {
		self.init()
		self.style = style
		self.showsZBarControls = false
		switch style {
		case .FullScreen:
			break
		case .Custom:
			self.cameraOverlayView = ZBarPickerOverlayView(frame: UIScreen.mainScreen().bounds)
			break
		}
	}

    override public func viewDidLoad() {
        super.viewDidLoad()

    }

	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		switch self.style {
		case .Custom:
			(self.cameraOverlayView as! ZBarPickerOverlayView).playScanAnim()
		default:
			break
		}
	}

	public override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		switch self.style {
		case .Custom:
			(self.cameraOverlayView as! ZBarPickerOverlayView).stopScanAnim()
		default:
			break
		}
	}

	public class func extractResult(info: [String : AnyObject]) -> String? {
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

extension ZBarSymbolSet: SequenceType {
	public func generate() -> NSFastGenerator {
		return NSFastGenerator(self)
	}
}
