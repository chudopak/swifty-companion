//
//  ProjectLists.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/11/22.
//

import Foundation

class ProjectLists {
	var projectCursusOrder = [Int]()
	var projectsLists = [Int: [Int]]()
	private var cursusProjectsSize = [Int: Int]()
	
	init(userData: [Project]? = nil) {
		guard let projects = userData else {
			return
		}
		setOrderAndCountSize(projects: projects)
	}
	
	private func setOrderAndCountSize(projects: [Project]) {
		for proj in projects {
			if (proj.cursus_ids.count != 0 && !proj.project.name.isNumeric) {
				if (!cursusProjectsSize.keys.contains(proj.cursus_ids[0])) {
					cursusProjectsSize[proj.cursus_ids[0]] = 0
					projectCursusOrder.append(proj.cursus_ids[0])
				} else {
					cursusProjectsSize[proj.cursus_ids[0]]! += 1
				}
			}
		}
	}
	
	private func setProjectsList(projects: [Project]) {
		for projIndex in projectCursusOrder {
//			projectsLists[projIndex] = Array
		}
	}
}
