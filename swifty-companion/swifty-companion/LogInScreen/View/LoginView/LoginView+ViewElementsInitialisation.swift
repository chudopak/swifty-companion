//
//  LoginView+ViewElementsInitialisation.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/23/22.
//

import UIKit

extension LoginView {
	
	func makeBackgroundImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = UIImage(named: "background")
		imageView.isUserInteractionEnabled = true
		addSubview(imageView)
		setBackgroundConstraints(for: imageView)
		return (imageView)
	}
	
	func makeLoginButton(superView: UIView) -> UIButton {
		let button = UIButton()
		button.backgroundColor = UIColor(named: "buttonsGreen")
		button.layer.cornerRadius = 5
		button.translatesAutoresizingMaskIntoConstraints = false
		superView.addSubview(button)
		setButtonConstraints(for: button, superView: superView)
		return (button)
	}
	
	func makeButtonTitleLabel(superView: UIView, textSize: CGFloat) -> UILabel {
		let label = UILabel()
		label.adjustsFontSizeToFitWidth = true
		label.textColor = .white
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: textSize)
		label.translatesAutoresizingMaskIntoConstraints = false
		superView.addSubview(label)
		setLabelConstraints(for: label, superView: superView)
		return (label)
	}
}
