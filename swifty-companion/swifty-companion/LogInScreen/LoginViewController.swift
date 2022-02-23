//
//  ViewController.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/19/22.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
	
	private var loginViewModel: LoginViewModelProtocol!
	
	lazy var usersButton: UIButton = {
		let button = UIButton()
		button.bounds.size = CGSize(width: 200, height: 50)
		button.backgroundColor = .green
		button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
		return (button)
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(usersButton)
		usersButton.center = view.center
	}
	
	init(loginViewModel: LoginViewModelProtocol) {
		self.loginViewModel = loginViewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	@objc private func signIn() {
		guard let signInURL = createSignInURL() else {
			print("Failed to create signIn URL")
			return
		}
		
		let authenticationSession = ASWebAuthenticationSession(url: signInURL, callbackURLScheme: API.callbackURL) { [weak self] callbackURL, error in
			self?.authenticationCompletion(callbackURL: callbackURL, error: error)
		}
		authenticationSession.presentationContextProvider = self
		authenticationSession.prefersEphemeralWebBrowserSession = true
		
		if !authenticationSession.start() {
			print("Failed to start ASWebAuthenticationSession")
		}
	}
	
	private func authenticationCompletion(callbackURL: URL?, error: Error?) {
		guard error == nil,
			  let callbackURL = callbackURL,
			  let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems,
			  let code = queryItems.first(where: {$0.name == "code" })?.value,
			  let codeExchangeURL = createCodeExchangeURL(code: code)
		else {
			print("An error occurred when attempting to sign in.")
			return
		}
		loginViewModel.getToken(codeExchangeURL: codeExchangeURL) { [weak self] result in
			switch result {
			case .success:
				//place for launching FindUser view controller
				let tabBar = TabBar()
				tabBar.modalPresentationStyle = .fullScreen
				self?.present(tabBar, animated: true, completion: nil)
				print("SUCCESS")
			case .fail:
				print("FAIL")
			}
		}
	}
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
	func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
		let window = UIApplication.shared.windows.first { $0.isKeyWindow }
		return window ?? ASPresentationAnchor()
	}
}
