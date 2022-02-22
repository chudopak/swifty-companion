//
//  ViewController.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/19/22.
//

import UIKit
import AuthenticationServices

enum CompleteStatus {
	case fail
	case success
}

class LoginViewController: UIViewController {
	
	private var loginViewModel: LoginViewModelProtocol!
	
	lazy var usersButton: UIButton = {
		let button = UIButton()
		button.bounds.size = CGSize(width: 200, height: 50)
		button.backgroundColor = .green
		button.addTarget(self, action: #selector(login), for: .touchUpInside)
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
	
//	@objc func getMe() {
//		let url = createURLWithComponents(path: "/v2/users/aa")
//		guard let url = url else {
//			print("Can't create URL")
//			return
//		}
//		var request = URLRequest(url: url)
//		request.httpMethod = "GET"
//		request.setValue("Bearer \(Token.accessToken!)", forHTTPHeaderField: "Authorization")
//		let sessions = URLSession.shared.dataTask(with: request) { data, response, error in
//			guard let response = response as? HTTPURLResponse else {
//			  print("Failed reequest")
//			  return
//			}
//			guard error == nil, let data = data else {
//			  print("error or data nil")
//			  return
//			}
//			print("data- ",data)
//			if let object = try? JSONDecoder().decode(User.self, from: data) {
//				print(object)
//			}
//
//		  }
//		sessions.resume()
//	}
	
	@objc private func login() {
		guard let signInURL = createSignInURL() else {
			print("Can't create signIn URL")
			return
		}
		
		let authenticationSession = ASWebAuthenticationSession(url: signInURL, callbackURLScheme: API.callbackURL) { [weak self] callbackURL, error in
			guard error == nil,
				  let callbackURL = callbackURL,
				  let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems,
				  let code = queryItems.first(where: {$0.name == "code" })?.value,
				  let codeExchangeURL = createCodeExchangeURL(code: code)
			else {
				print("An error occurred when attempting to sign in.")
				return
			}
			self?.loginViewModel.getToken(codeExchangeURL: codeExchangeURL, completionHandler: { result in
				switch result {
				case .success:
					//place for launching FindUser view controller
					print("SUCCESS")
				case .fail:
					print("FAIL")
				}
			})
		}
		authenticationSession.presentationContextProvider = self
		authenticationSession.prefersEphemeralWebBrowserSession = true
		
		if !authenticationSession.start() {
			print("Failed to start ASWebAuthenticationSession")
		}
	}
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
	func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
		let window = UIApplication.shared.windows.first { $0.isKeyWindow }
		return window ?? ASPresentationAnchor()
	}
}
