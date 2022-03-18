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
	
	enum FailCode: String {
		case networking = "Loading Error. Check internet connection and reload app."
		case userNotFound
		case unathorized
	}
}

struct UserData: Codable {
	var displayname: String
	var login: String
	var location: String?
	var wallet: Int
	var correction_point: Int
	var id: Int
	var url: String
	var image_url: String?
	var cursus_users: [Cursus]?
	var projects_users: [Project]?
	var campus: [Campus]?
}

struct Cursus: Codable {
	var cursus: CursusInfo
	var level: Double
	var skills: [Skill]
}

struct CursusInfo: Codable {
	var name: String
	var id: Int
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

enum SearchCoalitionStatus {
	case initial
	case success(CoalitionData)
	case failure
}

struct CoalitionData: Codable {
	var name: String
	var image_url: String
	var color: String
}


func printData(data: UserData) {
	print("DisplayName -- \(data.displayname )")
	print()
	print("login -- \(data.login)")
	print()
	print("Location -- \(data.location ?? "")")
	print()
	print("Wallet -- \(data.wallet )")
	print()
	print("Evaluation points -- \(data.correction_point )")
	print()
	print("ID -- \(data.id)")
	print()
	print("url -- \(data.url)")
	print()
	print("image url -- \(data.image_url ?? "")")
	print()
	print("Cursus user -- \(data.cursus_users ?? [Cursus]())")
	print()
	print("Progect user -- ")
//	if let proj = data.projects_users {
//		printProjects(projects: proj)
//	}
	print()
	print("Campus -- \(data.campus ?? [Campus]())")
}

func printProjects(projects: [Project]) {
	for proj in projects {
		print("Progect name - \(proj.project.name)")
		print("Progect ID - \(proj.project.id)")
		print("Progect Status - \(proj.status)")
		print("Final mark \(proj.final_mark ?? -1)")
		print("Cursus ids - \(proj.cursus_ids)")
		print("Validated - \(String(describing: proj.validated))")
		print()
	}
}

func printProjectLists(projects: ProjectLists) {
	for index in projects.projectCursusOrder {
		print("Cursus - \(index)")
		for i in projects.projectsLists[index]! {
			print("Progect name - \(i.projectName)")
			print("Progect Status - \(i.status)")
			print("Final mark \(i.finalMark)")
			print("Validated? - \(i.validated)")
			print()
		}
	}
 }
