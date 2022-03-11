//
//  LevelView.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/11/22.
//

import UIKit

let levelViewHeight: CGFloat = 25
let levelViewCornerRadius: CGFloat = 7

class LevelView: UIView {

	var levelInfo = LevelInfo() {
		didSet {
			levelLabel.text = "level \(levelInfo.levelInt) - \(levelInfo.levelPercentString) %"
			levelIndicator.backgroundColor = UIColor(hexString: levelInfo.color)
			print(levelInfo.levelPercentCGFloat)
			replaceWidthConstraint()
			layoutIfNeeded()
		}
	}
	
	private lazy var levelLabel = makeLevelLabel()
	private lazy var levelIndicator = makeLevelIndicator()
	
	private lazy var widthConstraint = NSLayoutConstraint()
	
	init() {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = UIColor(named: "UserInfoScreenBackgroundColor")
		layer.cornerRadius = levelViewCornerRadius
		clipsToBounds = true
		addSubview(levelIndicator)
		addSubview(levelLabel)
		setConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func replaceWidthConstraint() {
		NSLayoutConstraint.deactivate([widthConstraint])
		widthConstraint = levelIndicator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: levelInfo.levelPercentCGFloat)
		NSLayoutConstraint.activate([widthConstraint])
	}
}

extension LevelView {
	private func makeLevelIndicator() -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor(hexString: levelInfo.color)
		return (view)
	}
	
	private func makeLevelLabel() -> UILabel {
		let label = UILabel()
		label.numberOfLines = 2
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontSizeToFitWidth = true
		label.text = "level \(levelInfo.levelInt) - \(levelInfo.levelPercentString) %"
		label.textColor = .white
		label.font = UIFont.boldSystemFont(ofSize: 16)
		label.textAlignment = .center
		return (label)
	}
}


extension LevelView {
	
	private func setConstraints() {
		setLevelIndicatorViewConstraints(for: levelIndicator, superView: self)
		setLevelLabelConcstratins(for: levelLabel, superView: self)
	}
	
	private func setLevelIndicatorViewConstraints(for view: UIView, superView: UIView) {
		widthConstraint = view.widthAnchor.constraint(equalTo: superView.widthAnchor, multiplier: levelInfo.levelPercentCGFloat)
		NSLayoutConstraint.activate([
			widthConstraint,
			view.topAnchor.constraint(equalTo: superView.topAnchor),
			view.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
//			view.widthAnchor.constraint(equalTo: superView.widthAnchor, multiplier: 0.5),
			view.heightAnchor.constraint(equalToConstant: levelViewHeight)
		])
	}
	
	private func setLevelLabelConcstratins(for view: UIView, superView: UIView) {
		NSLayoutConstraint.activate([
			view.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
			view.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
			view.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
			view.heightAnchor.constraint(equalToConstant: levelViewHeight)
		])
	}
	
}
