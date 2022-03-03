//
//  LoginView.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/23/22.
//

import UIKit

class LoginView: UIView {

	private weak var delegate: LoginViewControllerDelegate!

	private lazy var backgroundImageView = makeBackgroundImageView()
	private lazy var loginButtonTitleLabel = makeButtonTitleLabel(superView: loginButton, textSize: loginViewTextSize)
	private lazy var loginButton = makeLoginButton(superView: backgroundImageView)
	
	init(delegate: LoginViewControllerDelegate, frame: CGRect) {
		super.init(frame: frame)
		self.delegate = delegate
		setUpView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func setUpView() {
		translatesAutoresizingMaskIntoConstraints = false
		loginButton.addTarget(self, action: #selector(signIn), for: UIControl.Event.touchUpInside)
		loginButtonTitleLabel.text = "SIGN IN"
	}
	
	@objc private func signIn() {
		delegate.signInDelegate()
	}	
}

extension LoginView {
	
	private func makeBackgroundImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = UIImage(named: "background")
		imageView.isUserInteractionEnabled = true
		addSubview(imageView)
		setBackgroundConstraints(for: imageView)
		return (imageView)
	}
	
	private func makeLoginButton(superView: UIView) -> GreenButton {
		let button = GreenButton()
		button.backgroundColor = UIColor(named: "buttonsGreen")
		button.layer.cornerRadius = cornerRadius
		button.translatesAutoresizingMaskIntoConstraints = false
		superView.addSubview(button)
		setButtonConstraints(for: button, superView: superView)
		return (button)
	}
	
	private func makeButtonTitleLabel(superView: UIView, textSize: CGFloat) -> UILabel {
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

extension LoginView {
	
	private func setBackgroundConstraints(for view: UIView) {
		NSLayoutConstraint.activate([
			view.leftAnchor.constraint(equalTo: leftAnchor),
			view.rightAnchor.constraint(equalTo: rightAnchor),
			view.topAnchor.constraint(equalTo: topAnchor),
			view.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
	
	private func setButtonConstraints(for view: UIView, superView: UIView) {
		NSLayoutConstraint.activate([
			view.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: loginButtonSideOffset),
			view.rightAnchor.constraint(equalTo: superView.rightAnchor, constant: -loginButtonSideOffset),
			view.heightAnchor.constraint(equalToConstant: loginButtonHeight),
			view.centerYAnchor.constraint(equalTo: superView.centerYAnchor)
		])
	}
	
	private func setLabelConstraints(for view: UIView, superView: UIView) {
		NSLayoutConstraint.activate([
			view.leftAnchor.constraint(equalTo: superView.leftAnchor),
			view.rightAnchor.constraint(equalTo: superView.rightAnchor),
			view.topAnchor.constraint(equalTo: superView.topAnchor),
			view.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
		])
	}
}
