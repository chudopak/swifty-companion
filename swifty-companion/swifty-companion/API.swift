//
//  API.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/22/22.
//

import Foundation

struct API {
	static let uid = "b642354b128b0e203de73888e9ddad3456b93fcf168ddbbeaf7f5801d183649b"
	static let secret = "f21ace76dc49e95ad47b71542a3916a7f3d9a217a78bd89b6e32042abb0425f7"
	static let tokenPath = "/oauth/token"
	static let authPath = "/oauth/authorize"
	static let host = "intra.42.fr"
	static let apiHost = "api.intra.42.fr"
	static let scope = "public profile"
	static let callbackURL = "swifty-companion"
	static let redirectURI = "swifty-companion://oauth-callback"
}

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
}

func createURLWithComponents(host: String = API.apiHost, path: String, queryItems: [URLQueryItem]? = nil) -> URL? {
	var urlComponents = URLComponents()
	urlComponents.scheme = "https"
	urlComponents.host = host
	urlComponents.path = path
	urlComponents.queryItems = queryItems
	return (urlComponents.url)
}

func createCodeExchangeURL(code: String) -> URL? {
	let queryItems = [
		URLQueryItem(name: "grant_type", value: "authorization_code"),
		URLQueryItem(name: "client_id", value: API.uid),
		URLQueryItem(name: "client_secret", value: API.secret),
		URLQueryItem(name: "code", value: code),
		URLQueryItem(name: "redirect_uri", value: API.redirectURI)
	]
	return (createURLWithComponents(host: API.apiHost, path: API.tokenPath, queryItems: queryItems))
}

func createSignInURL() -> URL? {
	let queryItems = [
		URLQueryItem(name: "client_id", value: API.uid),
		URLQueryItem(name: "redirect_uri", value: API.redirectURI),
		URLQueryItem(name: "scope", value: API.scope),
		URLQueryItem(name: "response_type", value: "code")
	]
	return (createURLWithComponents(host: API.apiHost, path: API.authPath, queryItems: queryItems))
}
