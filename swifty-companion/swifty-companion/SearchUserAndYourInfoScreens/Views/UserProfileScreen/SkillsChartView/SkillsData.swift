//
//  SkillsData.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/18/22.
//

import Foundation

let skillsNames: [String] = [
	"Adaptation & creativity",			"Algorithms & AI",				"Basics",
	"Company experience",				"DB & Data",					"Functional programming",
	"Graphics",							"Group & interpersonal",		"Imperative programming",
	"Network & system administration",	"Object-oriented programming",	"Organization",
	"Parallel computing",				"Rigor",						"Ruby",
	"Security",							"Shell",						"Technology integration",
	"Unix",								"Web"
]

let skillsNamesCompressed: [String] = [
	"""
	Adaptation
	&
	creativity
	""",
	"""
	Algorithms
	&
	AI
	""", "Basics",
	"""
	Company
	experience
	""",
	"""
	DB
	&
	Data
	""",
	"""
	Functional
	programming
	""", "Graphics",
	"""
	Group &
	interpersonal
	""",
	"""
	Imperative
	programming
	""",
	"""
	Network
	&
	system
	administration
	""",
	"""
	Object-
	oriented
	programming
	""",	"Organization",
	"""
	Parallel
	computing
	""", "Rigor","Ruby", "Security","Shell",
	"""
	Technology
	integration
	""", "Unix", "Web"
]


struct SkillData {
	let name: String
	var level: Double
	let index: Int
}

