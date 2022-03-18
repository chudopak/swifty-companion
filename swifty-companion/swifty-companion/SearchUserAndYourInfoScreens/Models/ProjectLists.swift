//
//  ProjectLists.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/11/22.
//

import Foundation

struct ProjectData {
	let finalMark: Int
	let projectName: String
	let status: String
	let validated: Bool
	
	init(proj: Project? = nil) {
		if let proj = proj {
			finalMark = proj.final_mark!
			projectName = proj.project.name
			status = proj.status
			validated = proj.validated ?? false
		} else {
			finalMark = -1
			projectName = ""
			status = ""
			validated = false
		}
	}
}


class ProjectLists {
	var projectCursusOrder = [Int]()
	var projectsLists = [Int: [ProjectData]]()
	var cursusNames = [Int: String]()
	private var cursusProjectsSize = [Int: Int]()
	
	init(userData: [Project]? = nil, cursus_user: [Cursus]? = nil) {
		guard let projects = userData else {
			return
		}
		if let cursus = cursus_user {
			for curs in cursus {
				cursusNames[curs.cursus.id] = curs.cursus.name
			}
		}
		print()
		print("CuRSUS NAMES", cursusNames)
		print()
		setOrderAndCountSize(projects: projects)
		setProjectsList(projects: projects)
	}
	
	private func setOrderAndCountSize(projects: [Project]) {
		for proj in projects {
			if (isVisibleForUser(project: proj)) {
				if (!cursusProjectsSize.keys.contains(proj.cursus_ids[0])) {
					cursusProjectsSize[proj.cursus_ids[0]] = 1
					projectCursusOrder.append(proj.cursus_ids[0])
				} else {
					cursusProjectsSize[proj.cursus_ids[0]]! += 1
				}
			}
		}
	}
	
	private func setProjectsList(projects: [Project]) {
		for projIndex in projectCursusOrder {
			projectsLists[projIndex] = Array<ProjectData>(repeating: ProjectData(), count: cursusProjectsSize[projIndex]!)
			var i = 0
			for proj in projects {
				if (isVisibleForUser(project: proj)
						&& proj.cursus_ids[0] == projIndex
						&& i < cursusProjectsSize[projIndex]!) {
					projectsLists[projIndex]![i] = ProjectData(proj: proj)
					i += 1
				}
			}
		}
	}
	
	private func sortLists() {
		for projIndex in projectCursusOrder {
			projectsLists[projIndex]!.sort(by: { first, second in
				first.projectName > second.projectName
			})
		}
	}
	
	private func isVisibleForUser(project: Project) -> Bool {
		if (project.cursus_ids.count != 0
				&& !project.project.name.isNumeric
				&& project.final_mark != nil
				&& project.final_mark! != -1
				&& project.validated != nil) {
			return (true)
		}
		return (false)
	}
}
