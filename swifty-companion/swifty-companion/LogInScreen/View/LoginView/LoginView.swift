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
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func setUpView() {
		translatesAutoresizingMaskIntoConstraints = false
		loginButton.addTarget(self, action: #selector(signIn), for: UIControl.Event.touchUpInside)
		loginButtonTitleLabel.text = "SIGN IN"
	}
	
	@objc private func signIn() {
		delegate.signInDelegate()
	}	
}
