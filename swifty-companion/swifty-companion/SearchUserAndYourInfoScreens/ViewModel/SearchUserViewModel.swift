//
//  SearchUserViewModel.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/1/22.
//

import UIKit

protocol SearchUserViewModelProtocol {
	var updateUserData: ((FetchStatus) -> ())? { get set }
	func fetchUserData(with url: URL)
}

final class SearchUserViewModel: SearchUserViewModelProtocol {
	var updateUserData: ((FetchStatus) -> ())?
	
	lazy var sessionConfiguration = _setURLSessionConfiguration()
	lazy var session = URLSession(configuration: sessionConfiguration)
	
	func fetchUserData(with url: URL) {

		updateUserData?(.loading)
		
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.get.rawValue
		request.setValue("Bearer \(Token.accessToken!)", forHTTPHeaderField: "Authorization")
		
		let getUserData = session.dataTask(with: request) { data, response, error in
			guard let response = response as? HTTPURLResponse,
				  response.statusCode == 200,
				  error == nil,
				  let data = data
			else {
				DispatchQueue.main.async {
					self.updateUserData?(.failure(.networking))
				}
				return
			}
			print(data)
			if let token = try? JSONDecoder().decode(UserData.self, from: data) {
				DispatchQueue.main.async {
					self.updateUserData?(.success(token))
				}
			} else {
				DispatchQueue.main.async {
					
				}
			}
			
			
		}
	}
	
	private func _setURLSessionConfiguration() -> URLSessionConfiguration {
		let configuration = URLSessionConfiguration.default
		configuration.waitsForConnectivity = true
		configuration.timeoutIntervalForResource = 30
		return (configuration)
	}
}
