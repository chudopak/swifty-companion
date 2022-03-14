//
//  ProjectsView.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/14/22.
//

import UIKit


class ProjectsScrollView: UIScrollView {

	var projectsLists: ProjectLists! {
		didSet {
			configureView()
		}
	}
	private var views = [UIView]()
	
	init() {
		super.init(frame: .zero)
		isPagingEnabled = true
		backgroundColor = UIColor(named: "UserInfoScreenBackgroundColor")
		layer.cornerRadius = cornerRadius
		clipsToBounds = true
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configureView() {
		for view in views {
			view.removeConstraints(view.constraints)
		}
		if (subviews.count != 0) {
			subviews.forEach({$0.removeFromSuperview()})
		}
		views.removeAll()
		if (projectsLists.projectCursusOrder.count == 0) {
			let noProjView = CursusProjectsTableView(projectsData: nil)
			views.append(noProjView)
			addSubview(noProjView)
		} else {
			views.reserveCapacity(projectsLists.projectCursusOrder.count)
			addViews()
		}
		setConstraints()
	}
	
	private func addViews() {
		for index in 0..<projectsLists.projectCursusOrder.count {
			let cursus = projectsLists.projectCursusOrder[index]
			views.append(CursusProjectsTableView(projectsData: projectsLists.projectsLists[cursus]!))
		}
		for view in views {
			addSubview(view)
		}
	}
	
	private func setConstraints() {
		for i in 0..<views.count {
			if (i == 0) {
				setFirstViewConstraints(for: views[i])
			}
			else {
				setViwsConstraints(for: views[i], leftView: views[i - 1])
			}
		}
		if (views.count != 0) {
			setContentLayoutGuideOnProjectsViews()
		}
	}
}

extension ProjectsScrollView {
	
	private func setFirstViewConstraints(for view: UIView) {
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: topAnchor),
			view.leadingAnchor.constraint(equalTo: leadingAnchor),
			view.widthAnchor.constraint(equalTo: widthAnchor),
			view.heightAnchor.constraint(equalToConstant: projectsScrollViewHeight)
		])
	}
	
	private func setViwsConstraints(for view: UIView, leftView: UIView) {
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: topAnchor),
			view.heightAnchor.constraint(equalToConstant: projectsScrollViewHeight),
			view.leadingAnchor.constraint(equalTo: leftView.trailingAnchor),
			view.widthAnchor.constraint(equalTo: leftView.widthAnchor)
		])
	}
	
	private func setContentLayoutGuideOnProjectsViews() {
		NSLayoutConstraint.activate([
			contentLayoutGuide.topAnchor.constraint(equalTo: views[0].topAnchor),
			contentLayoutGuide.bottomAnchor.constraint(equalTo: views[0].bottomAnchor),
			contentLayoutGuide.leadingAnchor.constraint(equalTo: views[0].leadingAnchor),
			contentLayoutGuide.trailingAnchor.constraint(equalTo: views[views.count - 1].trailingAnchor)
		])
	}
}
