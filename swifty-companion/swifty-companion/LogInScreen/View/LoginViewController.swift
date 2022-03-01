//
//  ViewController.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/19/22.
//

import UIKit
import AuthenticationServices

protocol LoginViewControllerDelegate: AnyObject {
	func signInDelegate()
}

class LoginViewController: UIViewController, LoginViewControllerDelegate {

	private var loginViewModel: LoginViewModelProtocol!
	private var loginView: LoginView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loginViewModel = LoginViewModel()
		loginView = LoginView(delegate: self, frame: view.bounds)
		view.addSubview(loginView)
		setViewConstraints()
		loginView.setUpView()
	}
	
	func signInDelegate() {
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
				self?.presentSearchUserScreen()
			case .fail(let val):
				print("An error is occured while sighing in - \(val.rawValue)")
			}
		}
	}
	
	private func presentSearchUserScreen() {
		let tabBar = TabBar()
		tabBar.modalPresentationStyle = .fullScreen
		present(tabBar, animated: true, completion: nil)
		print("SUCCESS")
	}
	
	private func setViewConstraints() {
		NSLayoutConstraint.activate([
			loginView.topAnchor.constraint(equalTo: view.topAnchor),
			loginView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			loginView.leftAnchor.constraint(equalTo: view.leftAnchor),
			loginView.rightAnchor.constraint(equalTo: view.rightAnchor)
		])
	}
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
	func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
		let window = UIApplication.shared.windows.first { $0.isKeyWindow }
		return window ?? ASPresentationAnchor()
	}
}
