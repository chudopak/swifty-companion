//
//  CursusProjectsView.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/14/22.
//

import UIKit

class CursusProjectsTableView: UIView, UITableViewDelegate, UITableViewDataSource {

	private var projectsData: [ProjectData]!
	private lazy var tableView = UITableView()
	
	init(projectsData: [ProjectData]) {
		super.init(frame: .zero)
		self.projectsData = projectsData
		translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.backgroundColor = .clear
		tableView.delegate = self
		tableView.dataSource = self
		tableView.allowsSelection = false
		tableView.register(ProjectInfoCell.self, forCellReuseIdentifier: ProjectInfoCell.identifier)
		addSubview(tableView)
		setTableViewConstratins(for: tableView)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (projectsData.count)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: ProjectInfoCell.identifier, for: indexPath) as? ProjectInfoCell {
			cell.projectData = projectsData[indexPath.row]
			return (cell)
		} else {
			let cell = ProjectInfoCell(style: .default, reuseIdentifier: nil)
			cell.projectData = projectsData[indexPath.row]
			return (cell)
		}
	}
//	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//		return (70)
//	}
	
}

extension CursusProjectsTableView {
	private func setTableViewConstratins(for view: UITableView) {
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: topAnchor),
			view.bottomAnchor.constraint(equalTo: bottomAnchor),
			view.leadingAnchor.constraint(equalTo: leadingAnchor),
			view.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
}
