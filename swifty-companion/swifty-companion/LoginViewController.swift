//
//  ViewController.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/19/22.
//

import UIKit
import AuthenticationServices

struct Constants {
	static let clientId = "b642354b128b0e203de73888e9ddad3456b93fcf168ddbbeaf7f5801d183649b"
	static let clientSecret = "f21ace76dc49e95ad47b71542a3916a7f3d9a217a78bd89b6e32042abb0425f7"
	static let tokenPath = "/oauth/token"
	static let authPath = "/oauth/authorize"
	static let host = "intra.42.fr"
	static let apiHost = "api.intra.42.fr"
	static let scope = "public profile"
	static let callbackURL = "swifty-companion"
	static let redirectURI = "swifty-companion://oauth-callback"
}

enum CompleteStatus {
	case fail
	case success
}

class LoginViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	func login() {
		guard let signInURL = createSignInURL() else {
			print("Can't create signIn URL")
			return
		}
		
		let authenticationSession = ASWebAuthenticationSession(url: signInURL, callbackURLScheme: Constants.callbackURL) { [weak self] callbackURL, error in
			guard error == nil,
				  let callbackURL = callbackURL,
				  let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems,
				  let code = queryItems.first(where: {$0.name == "code" })?.value,
				  let codeExchangeURL = self?.createCodeExchangeURL(code: code)
			else {
				print("An error occurred when attempting to sign in.")
				return
			}
			
			
		}
	}
	
	func netwirking(codeExchangeUrl: URL, completionHandler: @escaping ((CompleteStatus) -> Void)) {
		var request = URLRequest(url: codeExchangeUrl)
		
	}
	
	func createCodeExchangeURL(code: String) -> URL?{
		let queryItems = [
			URLQueryItem(name: "grant_type", value: "authorization_code"),
			URLQueryItem(name: "client_id", value: Constants.clientId),
			URLQueryItem(name: "client_secret", value: Constants.clientSecret),
			URLQueryItem(name: "code", value: code),
			URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
		]
		return (createURLWithComponents(host: Constants.apiHost, path: Constants.tokenPath, queryItems: queryItems))
	}
	
	func createSignInURL() -> URL? {
		let queryItems = [
			URLQueryItem(name: "client_id", value: Constants.clientId),
			URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
			URLQueryItem(name: "scope", value: Constants.scope),
			URLQueryItem(name: "response_type", value: "code")
		]
		return (createURLWithComponents(host: Constants.apiHost, path: Constants.authPath, queryItems: queryItems))
	}
	
	func createURLWithComponents(host: String = Constants.host, path: String, queryItems: [URLQueryItem]? = nil) -> URL? {
		var urlComponents = URLComponents()
		urlComponents.scheme = "https"
		urlComponents.host = host
		urlComponents.path = path
		urlComponents.queryItems = queryItems
		return (urlComponents.url)
	}

}

