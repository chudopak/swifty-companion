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
	
	private var chartViewControllers = [ChartViewController]()
	
	var cursus: [Cursus]? {
		didSet {
			setPageViewController()
		}
	}
	
	private var currentView = 0
	
	init(cursus: [Cursus]? = nil) {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = UIColor(named: "UserInfoScreenBackgroundColor")
		layer.cornerRadius = cornerRadius
		clipsToBounds = true
		pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
		addSubview(pageViewController.view)
		setPageViewContraints(for: pageViewController.view)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setPageViewController() {
		chartViewControllers.removeAll()
		pageViewController.delegate = self
		pageViewController.dataSource = self
		for i in 0..<4 {
			let vc = ChartViewController(i: i)
			chartViewControllers.append(vc)
		}
		guard let first = chartViewControllers.first else {
			return
		}
		pageViewController.setViewControllers([first], direction: .forward, animated: true)
		
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		guard let vc = viewController as? ChartViewController,
			  let index = chartViewControllers.firstIndex(of: vc),
			  index > 0 else {
			return nil
		}
		let after = index - 1
		currentView = after
		print("CURRENT VIEW BEFORE \(currentView)")
		return (chartViewControllers[currentView])
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		guard let vc = viewController as? ChartViewController,
			  let index = chartViewControllers.firstIndex(of: vc),
			  index < (chartViewControllers.count - 1) else {
			return nil
		}
		let after = index + 1
		currentView = after
		print("CURRENT VIEW AFTER \(currentView)")
		return (chartViewControllers[currentView])
	}
	
	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return (chartViewControllers.count)
	}
	
	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		return (currentView)
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
}
