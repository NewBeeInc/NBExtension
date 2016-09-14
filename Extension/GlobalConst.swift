//
//  GlobalConst.swift
//  Aura
//
//  Created by Ke Yang on 4/18/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import Foundation
import UIKit

// MARK: - App Version & Build No.

/// App version
public let APP_VERSION: NSString = {
	if let infoDict = BUNDLE_MAIN.infoDictionary {
		if let versionString = infoDict["CFBundleShortVersionString"] as? NSString {
			return versionString
		}
	}
	return "" as NSString
}()

/// App build no.
public let APP_BUILD_INDEX: NSString = {
	if let infoDict = BUNDLE_MAIN.infoDictionary {
		if let buildIndexString = infoDict["CFBundleVersion"] as? NSString {
			return buildIndexString
		}
	}
	return "" as NSString
}()

// MARK: - TimeInterval

public let TIMEINTERVAL_ANIMATION_DEFAULT = 0.25

// MARK: - CGMAX series

/// CGFloat极值快速访问
public let CGFLOAT_MAX = CGFloat(MAXFLOAT)

/// CGSize极值快速访问
public let CGSIZE_MAX  = CGSize(width: CGFLOAT_MAX, height: CGFLOAT_MAX)
