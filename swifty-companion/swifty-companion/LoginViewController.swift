//
//  ViewController.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/19/22.
//

import UIKit

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

class LoginViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
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

