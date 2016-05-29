//
//  IntExtension.swift
//  Aura
//
//  Created by keyOfVv on 1/8/16.
//  Copyright © 2016 com.sangebaba. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Int与CGFloat的便捷转换

public extension Int {

	/// 转换为CGFloat
	public var cgFloat: CGFloat { return CGFloat(self) }
	/// 转换为Float
	public var float: Float { return Float(self) }
	/// 转换为Double
	public var double: Double { return Double(self) }
}
