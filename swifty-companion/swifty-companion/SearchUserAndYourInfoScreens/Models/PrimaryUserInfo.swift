//
//  PrimaryUserInfo.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/11/22.
//

import Foundation

struct PrimaryUserInfo {
	var displayName: String
	var wallet: Int
	var correction_point: Int
	var campus: String
	var image_url: String?
	
	init() {
		displayName = ""
		wallet = -1
		correction_point = -1
		campus = "None"
	}
	
	init(userData: UserData) {
		displayName = userData.displayname
		wallet = userData.wallet
		correction_point = userData.correction_point
		campus = userData.campus?[0].name ?? "None"
		image_url = userData.image_url
	}
}
