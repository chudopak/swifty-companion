//
//  UserModel.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/22/22.
//

import Foundation

enum SearchUserStatus {
	case initial
	case loading
	case success(UserData)
	case failure(FailCode)
	
	enum FailCode {
		case networking
		case userNotFound
	}
}

struct UserData: Codable {
	var displayname: String?
	var login: String
	var location: String?
	var wallet: Int?
	var correction_point: Int?
	var id: Int
	var url: String
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
