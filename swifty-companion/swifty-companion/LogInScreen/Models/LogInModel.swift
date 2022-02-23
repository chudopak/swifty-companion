//
//  LogInModel.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/22/22.
//

import Foundation

struct Token: Codable {
	
	private static let accessTokenKey = "accessToken"
	private static let refreshTokenKey = "refreshToken"

	static var accessToken: String? {
		get {
			UserDefaults.standard.string(forKey: accessTokenKey)
		}
		set {
			UserDefaults.standard.setValue(newValue, forKey: accessTokenKey)
		}
	}

	static var refreshToken: String? {
		get {
			UserDefaults.standard.string(forKey: refreshTokenKey)
		}
		set {
			UserDefaults.standard.setValue(newValue, forKey: refreshTokenKey)
		}
	}
	
	var access_token: String
	var token_type: StringLiteralType
	var expires_in: Int
	var refresh_token: String
	var scope: String
	var created_at: Int
}

enum LoginCompleteStatus {
	case fail
	case success
}
