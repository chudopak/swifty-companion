//
//  PrimaryUserInfoView.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/10/22.
//

import UIKit

class PrimaryUserInfoView: UIView {

	var primaryUserInfo: PrimaryUserInfo = PrimaryUserInfo() {
		didSet {
			updateInfo()
			setNeedsLayout()
		}
	}
	
	private lazy var baseView = makeBaseView()
	private lazy var profilePictureImageView = makeProfilePictureImageView()
	private lazy var walletLabel = makeLabel(text: "Wallet", textSize: 17, alignment: .left, bold: true, sizeToFit: true)
	private lazy var evaluationPointsLabel = makeLabel(text: "Evaluation Points", textSize: 17, alignment: .left, bold: true, sizeToFit: true)
	private lazy var campusLabel = makeLabel(text: "Campus", textSize: 17, alignment: .left, bold: true, sizeToFit: true)
	
	private lazy var userName = makeBoldLabel(text: primaryUserInfo.displayName, textSize: 19, alignment: .center)
	private lazy var walletValueLabel = makeLabel(text: String(primaryUserInfo.wallet), textSize: 17, alignment: .right, bold: false)
	private lazy var evaluationPointsValueLabel = makeLabel(text: String(primaryUserInfo.correction_point), textSize: 17, alignment: .right, bold: false)
	private lazy var campusValueLabel = makeLabel(text: primaryUserInfo.campus, textSize: 17, alignment: .right, bold: false)
	
	private lazy var walletView = makeElementView(leftLabel: walletLabel, rightLabel: walletValueLabel)
	private lazy var evaluationPointsView = makeElementView(leftLabel: evaluationPointsLabel, rightLabel: evaluationPointsValueLabel)
	private lazy var campusView = makeElementView(leftLabel: campusLabel, rightLabel: campusValueLabel)
	
	private lazy var stackView = makeStackView()
	
	
	init() {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		addSubview(profilePictureImageView)
		addSubview(stackView)
		stackView.addArrangedSubview(userName)
		stackView.addArrangedSubview(walletView)
		stackView.addArrangedSubview(evaluationPointsView)
		stackView.addArrangedSubview(campusView)
		setConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func updateInfo() {
		if let imageLink = primaryUserInfo.image_url, let url = URL(string: imageLink) {
			profilePictureImageView.download(from: url, defaultImageName: "noImage")
		} else {
			profilePictureImageView.image = UIImage(named: "noImage")
		}
		userName.text = primaryUserInfo.displayName
		walletValueLabel.text = String(primaryUserInfo.wallet)
		evaluationPointsValueLabel.text = String(primaryUserInfo.correction_point)
		campusValueLabel.text = primaryUserInfo.campus
	}
	
}

extension PrimaryUserInfoView {
	
	private func makeBaseView() -> UIView {
		let baseView = UIView()
		baseView.translatesAutoresizingMaskIntoConstraints = false
		return (baseView)
	}
	
	private func makeProfilePictureImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.layer.cornerRadius = profilePictureSize / 2
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return (imageView)
	}
	
	private func makeLabel(text: String, textSize: CGFloat, alignment: NSTextAlignment, bold: Bool, sizeToFit: Bool = true) -> UILabel {
		let label = UILabel()
		if (sizeToFit) {
			label.sizeToFit()
		}
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.textAlignment = alignment
		label.text = text
		label.textColor = .white
		if (bold) {
			label.font = UIFont.boldSystemFont(ofSize: textSize)
		} else {
			label.font = UIFont.systemFont(ofSize: textSize)
		}
		label.adjustsFontSizeToFitWidth = true
		return (label)
	}
	
	private func makeBoldLabel(text: String, textSize: CGFloat, alignment: NSTextAlignment) -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.textAlignment = alignment
		label.textColor = .white
		label.text = text
		label.font = UIFont.boldSystemFont(ofSize: textSize)
		label.adjustsFontSizeToFitWidth = true
		return (label)
	}
	
	private func makeElementStackView(leftLabel: UILabel, rightLabel: UILabel) -> UIStackView {
		let view = UIStackView()
		view.axis = .vertical
		view.distribution = .equalSpacing
		view.spacing = 7
		view.translatesAutoresizingMaskIntoConstraints = false
		view.addArrangedSubview(leftLabel)
		view.addArrangedSubview(rightLabel)
		return (view)
	}
	
	private func makeElementView(leftLabel: UILabel, rightLabel: UILabel) -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(leftLabel)
		view.addSubview(rightLabel)
		NSLayoutConstraint.activate([
			leftLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			leftLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor)
		])
		NSLayoutConstraint.activate([
			rightLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			rightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			rightLabel.leadingAnchor.constraint(equalTo: leftLabel.leadingAnchor)
		])
		return (view)
	}
	
	private func makeStackView() -> UIStackView {
		let view = UIStackView()
		view.axis = .vertical
		view.distribution = .fillEqually
		view.spacing = 5
		view.translatesAutoresizingMaskIntoConstraints = false
		return (view)
	}
}

extension PrimaryUserInfoView {
	
	private func setConstraints() {
		setProfilePictureConstraints()
		setStackViewConstraints()
	}
	
	private func setProfilePictureConstraints() {
		NSLayoutConstraint.activate([
			profilePictureImageView.topAnchor.constraint(equalTo: topAnchor),
			profilePictureImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			profilePictureImageView.heightAnchor.constraint(equalToConstant: profilePictureSize),
			profilePictureImageView.widthAnchor.constraint(equalToConstant: profilePictureSize)
		])
	}
	
	private func setStackViewConstraints() {
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
			stackView.heightAnchor.constraint(equalToConstant: profilePictureSize),
			stackView.leadingAnchor.constraint(equalTo: profilePictureImageView.trailingAnchor, constant: spaceBetweenPictureAndStackView)
		])
	}
}
