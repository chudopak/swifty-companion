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
	
	init() {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = .yellow
		addSubview(profilePictureImageView)
		setConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func updateInfo() {
		if let imageLink = primaryUserInfo.image_url, let url = URL(string: imageLink) {
			profilePictureImageView.download(from: url)
		} else {
			profilePictureImageView.image = UIImage(systemName: "person.fill.questionmark")
		}
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
}

extension PrimaryUserInfoView {
	
	private func setConstraints() {
		setProfilePictureConstraints()
	}
	
	private func setProfilePictureConstraints() {
		NSLayoutConstraint.activate([
			profilePictureImageView.topAnchor.constraint(equalTo: topAnchor),
			profilePictureImageView.leftAnchor.constraint(equalTo: leftAnchor),
			profilePictureImageView.heightAnchor.constraint(equalToConstant: profilePictureSize),
			profilePictureImageView.widthAnchor.constraint(equalToConstant: profilePictureSize)
		])
	}
}
