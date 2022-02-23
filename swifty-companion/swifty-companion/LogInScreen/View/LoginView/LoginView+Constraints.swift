//
//  LoginView+Constraints.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/23/22.
//

import UIKit

extension LoginView {
	
	func setBackgroundConstraints(for view: UIView) {
		NSLayoutConstraint.activate([
			view.leftAnchor.constraint(equalTo: leftAnchor),
			view.rightAnchor.constraint(equalTo: rightAnchor),
			view.topAnchor.constraint(equalTo: topAnchor),
			view.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
	
	func setButtonConstraints(for view: UIView, superView: UIView) {
		NSLayoutConstraint.activate([
			view.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: loginButtonSideOffset),
			view.rightAnchor.constraint(equalTo: superView.rightAnchor, constant: -loginButtonSideOffset),
			view.heightAnchor.constraint(equalToConstant: loginButtonHeight),
			view.centerYAnchor.constraint(equalTo: superView.centerYAnchor)
		])
	}
	
	func setLabelConstraints(for view: UIView, superView: UIView) {
		NSLayoutConstraint.activate([
			view.leftAnchor.constraint(equalTo: superView.leftAnchor),
			view.rightAnchor.constraint(equalTo: superView.rightAnchor),
			view.topAnchor.constraint(equalTo: superView.topAnchor),
			view.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
		])
	}
}
