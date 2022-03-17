//
//  SkillsChartView.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/16/22.
//

import UIKit

class SkillsChartView: UIView, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
	
	
	private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll,
															   navigationOrientation: .horizontal,
															   options: nil)
	private lazy var noSkillsLabel = makeNoSkillsLabel()
	
	private var chartViewControllers = [ChartViewController]()
	
	var cursus: [Cursus]? {
		didSet {
			setPageViewController()
		}
	}
	
	init(cursus: [Cursus]? = nil) {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = UIColor(named: "UserInfoScreenBackgroundColor")
		layer.cornerRadius = cornerRadius
		clipsToBounds = true
		pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
		pageViewController.delegate = self
		pageViewController.dataSource = self
		addSubview(pageViewController.view)
		addSubview(noSkillsLabel)
		noSkillsLabel.isHidden = true
		setPageViewContraints(for: pageViewController.view)
		setNoSkillsLabelConstraints(for: noSkillsLabel)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setPageViewController() {
		chartViewControllers.removeAll(keepingCapacity: true)
		let amountOfCharts = countSkillsCharts()
		guard amountOfCharts != 0, let cursus = cursus else {
			pageViewController.view.isHidden = true
			noSkillsLabel.isHidden = false
			return
		}
		chartViewControllers.reserveCapacity(amountOfCharts)
		for i in 0..<cursus.count {
			if (cursus[i].skills.count != 0) {
				let vc = ChartViewController(skills: cursus[i].skills, cursus_name: cursus[i].cursus.name)
				chartViewControllers.append(vc)
			}
		}
		guard let first = chartViewControllers.first else {
			pageViewController.view.isHidden = true
			noSkillsLabel.isHidden = false
			return
		}
		pageViewController.setViewControllers([first], direction: .forward, animated: true)
	}
	
	private func countSkillsCharts() -> Int {
		guard let cursus = cursus else {
			return (0)
		}
		var amountOfCharts = 0
		for curs in cursus {
			if (curs.skills.count != 0) {
				amountOfCharts += 1
			}
		}
		return (amountOfCharts)
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		guard let vc = viewController as? ChartViewController,
			  let index = chartViewControllers.firstIndex(of: vc),
			  index > 0 else {
			return nil
		}
		let before = index - 1
		return (chartViewControllers[before])
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		guard let vc = viewController as? ChartViewController,
			  let index = chartViewControllers.firstIndex(of: vc),
			  index < (chartViewControllers.count - 1) else {
			return nil
		}
		let after = index + 1
		return (chartViewControllers[after])
	}
	
	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return (chartViewControllers.count)
	}
	
	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		return (0)
	}
}

extension SkillsChartView {
	
	private func makeNoSkillsLabel() -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 24)
		label.textColor = .white
		label.adjustsFontSizeToFitWidth = true
		label.text = "No Skills Available"
		return label
	}
}

extension SkillsChartView {
		
	private func setPageViewContraints(for view: UIView) {
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: topAnchor),
			view.bottomAnchor.constraint(equalTo: bottomAnchor),
			view.leadingAnchor.constraint(equalTo: leadingAnchor),
			view.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
	
	private func setNoSkillsLabelConstraints(for view: UIView) {
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: topAnchor),
			view.bottomAnchor.constraint(equalTo: bottomAnchor),
			view.leadingAnchor.constraint(equalTo: leadingAnchor),
			view.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
}
