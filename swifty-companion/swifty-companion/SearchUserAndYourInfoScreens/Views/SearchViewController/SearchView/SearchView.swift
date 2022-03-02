//
//  SearchView.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/2/22.
//

import UIKit

class SearchView: UIView {

	lazy var backgroundImageView = makeBackgroundImageView()
	
	init() {
		super.init(frame: CGRect.zero)
		translatesAutoresizingMaskIntoConstraints = false
		addSubview(backgroundImageView)
		setConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
