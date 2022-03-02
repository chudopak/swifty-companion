//
//  SearchView+Constraints.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/2/22.
//

import UIKit

extension SearchView {
	
	func setBackgroudConstraints(for view: UIView) {
		NSLayoutConstraint.activate([
			view.leftAnchor.constraint(equalTo: leftAnchor),
			view.rightAnchor.constraint(equalTo: rightAnchor),
			view.topAnchor.constraint(equalTo: topAnchor),
			view.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
	
	func setConstraints() {
		setBackgroudConstraints(for: backgroundImageView)
	}
}
