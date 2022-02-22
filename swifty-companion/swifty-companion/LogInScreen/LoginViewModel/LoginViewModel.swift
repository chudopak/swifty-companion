//
//  LoginViewModel.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/22/22.
//

import UIKit

protocol LoginViewModelProtocol {
	func getToken(codeExchangeURL: URL, completionHandler: @escaping ((CompleteStatus) -> Void))
}

final class LoginViewModel: LoginViewModelProtocol {
	
	lazy var sessionConfiguration = _setURLSessionConfiguration()
	lazy var session = URLSession(configuration: sessionConfiguration)
	
	func getToken(codeExchangeURL: URL, completionHandler: @escaping ((CompleteStatus) -> Void)) {
		
		var request = URLRequest(url: codeExchangeURL)
		request.httpMethod = HTTPMethod.post.rawValue
		
		let getTokenTask = session.dataTask(with: request) { data, response, error in
			guard let response = response as? HTTPURLResponse,
				  response.statusCode == 200
			else {
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
				Token.accessToken = token!.access_token
				Token.refreshToken = token!.refresh_token
				completionHandler(CompleteStatus.success)
			}
			return
		}
		getTokenTask.resume()
	}
	
	private func _setURLSessionConfiguration() -> URLSessionConfiguration {
		let configuration = URLSessionConfiguration.default
		configuration.waitsForConnectivity = true
		configuration.timeoutIntervalForResource = 30
		return (configuration)
	}
	
	
}
