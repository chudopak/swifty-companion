//
//  LoginButton.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/1/22.
//

import UIKit

class GreenButton: UIButton {

	override var isHighlighted: Bool {
		didSet {
			backgroundColor = isHighlighted ? UIColor(named: "buttonHighlight") : UIColor(named: "buttonsGreen")
		}
	}

}
