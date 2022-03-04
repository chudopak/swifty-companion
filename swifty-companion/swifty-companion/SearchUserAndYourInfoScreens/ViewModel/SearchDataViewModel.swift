//
//  SearchUserViewModel.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/1/22.
//

import UIKit

protocol SearchUserProtocol {
	var updateUserData: ((SearchUserStatus) -> ())? { get set }
	func fetchUserData(with url: URL)
}

protocol SearchCoalitionProtocol {
	var updateCoalitionData: ((SearchCoalitionStatus) -> ())? {get set}
	func fetchCoalitionData(with url: URL)
}

final class SearchDataViewModel: SearchUserProtocol, SearchCoalitionProtocol {
	
	var updateCoalitionData: ((SearchCoalitionStatus) -> ())?
	var updateUserData: ((SearchUserStatus) -> ())?
	
	lazy var sessionUserDataConfiguration = _setURLSessionConfiguration(timeInterval: 30)
	lazy var sessionUserData = URLSession(configuration: sessionUserDataConfiguration)
	
	lazy var sessionCoalitionDataConfiguration = _setURLSessionConfiguration(timeInterval: 10)
	lazy var sessionCoalitionData = URLSession(configuration: sessionCoalitionDataConfiguration)
	
	func fetchUserData(with url: URL) {

		updateUserData?(.loading)
		
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.get.rawValue
		request.setValue("Bearer \(Token.accessToken!)", forHTTPHeaderField: "Authorization")
		
		let getUserData = sessionUserData.dataTask(with: request) { [weak self] data, response, error in
			guard error == nil,
				  let data = data
			else {
				self?.dispatchMainAsync(status: SearchUserStatus.failure(.networking))
				return
			}
			guard let htttpResponse = response as? HTTPURLResponse, (200...299).contains(htttpResponse.statusCode) else {
				let htttpResponse = response as? HTTPURLResponse
				print("Status code", htttpResponse?.statusCode ?? 0)
				self?.dispatchMainAsync(status: SearchUserStatus.failure(.userNotFound))
				return
			}
			if let userData = try? JSONDecoder().decode(UserData.self, from: data) {
				self?.dispatchMainAsync(status: SearchUserStatus.success(userData))
			} else {
				self?.dispatchMainAsync(status: SearchUserStatus.failure(.userNotFound))
			}
		}
		getUserData.resume()
	}
	
	func fetchCoalitionData(with url: URL) {
		
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.get.rawValue
		request.setValue("Bearer \(Token.accessToken!)", forHTTPHeaderField: "Authorization")
		
		let getCoalition = sessionCoalitionData.dataTask(with: request) { [weak self] data, responce, error in
			guard error == nil,
				  let data = data
			else {
				self?.dispatchMainAsync(status: SearchCoalitionStatus.failure)
				return
			}
			guard let htttpResponse = responce as? HTTPURLResponse, (200...299).contains(htttpResponse.statusCode) else {
				let response = responce as? HTTPURLResponse
				print("Status code", response?.statusCode ?? 0)
				self?.dispatchMainAsync(status: SearchCoalitionStatus.failure)
				return
			}
			if let coalitionData = CoalitionJSONDecoder.decodeCoalitionInfo(data: data) {
				self?.dispatchMainAsync(status: SearchCoalitionStatus.success(coalitionData))
			} else {
				print("Here ERORRORRORORO")
				self?.dispatchMainAsync(status: SearchCoalitionStatus.failure)
			}
		}
		getCoalition.resume()
	}
	
	private func dispatchMainAsync(status: SearchUserStatus) {
		DispatchQueue.main.async {
			self.updateUserData?(status)
		}
	}
	
	private func dispatchMainAsync(status: SearchCoalitionStatus) {
		DispatchQueue.main.async {
			self.updateCoalitionData?(status)
		}
	}
	
	private func _setURLSessionConfiguration(timeInterval: TimeInterval) -> URLSessionConfiguration {
		let configuration = URLSessionConfiguration.default
		configuration.waitsForConnectivity = true
		configuration.timeoutIntervalForResource = timeInterval
		return (configuration)
	}
}
