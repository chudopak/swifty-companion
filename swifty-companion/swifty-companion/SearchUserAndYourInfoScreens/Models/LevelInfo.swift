//
//  LevelInfo.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/11/22.
//

import UIKit

struct LevelInfo {
	let color: String
	let levelInt: String
	let levelPercentString: String
	let levelPercentCGFloat: CGFloat
	
	init(level: Double = 0.0, color: String = "#00babc") {
		self.color = color
		let nb = Int(level)
		self.levelInt = String(nb)
		let tmpLevel = Int(level * 100)
		self.levelPercentString = String(tmpLevel - nb * 100)
		self.levelPercentCGFloat = CGFloat(level - Double(nb))
	}
}
