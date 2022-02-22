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

struct User: Codable {
	var id:     Int?
	var login:  String?
	var displayname: String?
	var url:    String?
	var location: String?
	var wallet: Int?
	var correction_point: Int?
	var image_url: String?
	var cursus_users: [Cursus]?
	var projects_users: [Project]?
	var campus: [Campus]?
}

struct Cursus: Codable {
	var level: Double
	var skills: [Skill]
}

struct Skill: Codable {
	var name: String
	var level: Double
}

struct Project: Codable {
	var final_mark: Int?
	var project: ProjectDetails
	var cursus_ids: [Int]
	var status: String
	var validated: Bool?
  
  enum CodingKeys: String, CodingKey {
	case validated = "validated?"
	case final_mark, project, cursus_ids, status
  }
}

struct ProjectDetails: Codable {
	var id: Int
  var name: String
	var slug: String
	var parent_id: Int?
}

struct Campus: Codable {
	var name: String
}

enum CompleteStatus {
	case fail
	case success
}

struct Token: Codable {
  var access_token: String
  var token_type: StringLiteralType
  var expires_in: Int
  var refresh_token: String
  var scope: String
  var created_at: Int
}

class LoginViewController: UIViewController {
	
	var tokenita = Token(access_token: "", token_type: "", expires_in: 1, refresh_token: "", scope: "", created_at: 1)
	
	lazy var usersButton: UIButton = {
		let button = UIButton()
		button.bounds.size = CGSize(width: 200, height: 50)
		button.backgroundColor = .green
		button.addTarget(self, action: #selector(getMe), for: .touchUpInside)
		return (button)
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(usersButton)
		usersButton.center = view.center
		login()
	}
	
	@objc func getMe() {
		let url = createURLWithComponents(path: "/v2/users/aa")
		guard let url = url else {
			print("Can't create URL")
			return
		}
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("Bearer \(tokenita.access_token)", forHTTPHeaderField: "Authorization")
		let sessions = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let response = response as? HTTPURLResponse else {
			  print("Failed reequest")
			  return
			}
			guard error == nil, let data = data else {
			  print("error or data nil")
			  return
			}
//			var jsonData: [Any]?
//			do {
//				jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
//			} catch {
//				print("JSON ERROR \(error)")
//			}
//			print(jsonData)
			print("data- ",data)
			if let object = try? JSONDecoder().decode(User.self, from: data) {
				print(object)
			}
			  
		  }
		sessions.resume()
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
			self?.networking(codeExchangeUrl: codeExchangeURL, completionHandler: { result in
				switch result {
				case .success:
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
	
	func networking(codeExchangeUrl: URL, completionHandler: @escaping ((CompleteStatus) -> Void)) {
		var request = URLRequest(url: codeExchangeUrl)
		request.httpMethod = "POST"
		let session = URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
		  guard let response = response as? HTTPURLResponse else {
			DispatchQueue.main.async {
			  completionHandler(CompleteStatus.fail)
			}
			return
		  }
		  guard error == nil, let data = data else {
			DispatchQueue.main.async {
			  completionHandler(CompleteStatus.fail)
			}
			return
		  }
			print(data)
			let token = try? JSONDecoder().decode(Token.self, from: data)
			DispatchQueue.main.async {
				self?.tokenita.access_token = token!.access_token
				self?.tokenita.refresh_token = token!.refresh_token
			  print(token!.access_token)
			  print(token!.refresh_token)
			  completionHandler(CompleteStatus.success)
			}
			return
		}
		session.resume()
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
	
	func createURLWithComponents(host: String = Constants.apiHost, path: String, queryItems: [URLQueryItem]? = nil) -> URL? {
		var urlComponents = URLComponents()
		urlComponents.scheme = "https"
		urlComponents.host = host
		urlComponents.path = path
		urlComponents.queryItems = queryItems
		return (urlComponents.url)
	}

}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession)
  -> ASPresentationAnchor {
	let window = UIApplication.shared.windows.first { $0.isKeyWindow }
	return window ?? ASPresentationAnchor()
  }
}
