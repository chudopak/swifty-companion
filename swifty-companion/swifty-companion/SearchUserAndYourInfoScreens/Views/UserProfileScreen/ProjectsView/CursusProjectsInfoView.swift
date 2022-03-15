//
//  CursusProjectsView.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/14/22.
//

import UIKit

class CursusProjectsInfoView: UIView, UITableViewDelegate, UITableViewDataSource {

	private var projectsData: [ProjectData]!
	private lazy var tableView = UITableView()
	private lazy var noProjectsLabel = makeNoProjectsLabel()
	private lazy var cursusNameLabel = makeCursusNameLabel()
	
	init(projectsData: [ProjectData]?, cursusName: String) {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		if let data = projectsData {
			self.projectsData = data
			tableView.translatesAutoresizingMaskIntoConstraints = false
			tableView.backgroundColor = .clear
			tableView.delegate = self
			tableView.dataSource = self
			tableView.allowsSelection = false
			tableView.register(ProjectInfoCell.self, forCellReuseIdentifier: ProjectInfoCell.identifier)
			addSubview(tableView)
			addSubview(cursusNameLabel)
			cursusNameLabel.text = cursusName
			setCursusNameLabelConstraints(for: cursusNameLabel)
			setTableViewConstratins(for: tableView, superView: cursusNameLabel)
		} else {
			addSubview(noProjectsLabel)
			setLabelConstraints(for: noProjectsLabel)
		}
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
}

extension CursusProjectsInfoView {

	private func makeNoProjectsLabel() -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 24)
		label.textColor = .white
		label.adjustsFontSizeToFitWidth = true
		label.text = "No Finished Projects"
		return (label)
	}
	
	private func makeCursusNameLabel() -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.textAlignment = .left
		label.font = UIFont.systemFont(ofSize: 24)
		label.textColor = .white
		label.adjustsFontSizeToFitWidth = true
		return (label)
	}
}

extension CursusProjectsInfoView {
	
	private func setCursusNameLabelConstraints(for view: UILabel) {
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: topAnchor),
			view.heightAnchor.constraint(equalToConstant: projectsViewCursusNameHeight),
			view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: projectsViewLabelsSizeOffset),
			view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -projectsViewLabelsSizeOffset)
		])
	}
	
	private func setTableViewConstratins(for view: UITableView, superView: UIView) {
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: superView.bottomAnchor),
			view.bottomAnchor.constraint(equalTo: bottomAnchor),
			view.leadingAnchor.constraint(equalTo: leadingAnchor),
			view.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
	
	private func setLabelConstraints(for view: UIView) {
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: topAnchor),
			view.leadingAnchor.constraint(equalTo: leadingAnchor),
			view.widthAnchor.constraint(equalTo: widthAnchor),
			view.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
