//
//  LocationInClasterView.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/11/22.
//

import UIKit

class LocationInClasterView: UIView {

	var location: String = "" {
		didSet {
			locationLabel.text = location
			setNeedsLayout()
		}
	}
	
	private lazy var locationLabel = makeLocationLabel()
	
	init() {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		addSubview(locationLabel)
		backgroundColor = UIColor(named: "UserInfoScreenBackgroundColor")
		layer.cornerRadius = locationInClasterViewCornerRadius
		setLocationLabelConstraints(for: locationLabel)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension LocationInClasterView {
	private func makeLocationLabel() -> UILabel{
		let label = UILabel()
		label.numberOfLines = 2
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontSizeToFitWidth = true
		label.text = ""
		label.textColor = .white
		label.font = UIFont.boldSystemFont(ofSize: 24)
		label.textAlignment = .center
		return (label)
	}
}

extension LocationInClasterView {
	private func setLocationLabelConstraints(for view: UIView) {
		NSLayoutConstraint.activate([
			view.heightAnchor.constraint(equalToConstant: locationInClasterViewHeight),
			view.centerXAnchor.constraint(equalTo: centerXAnchor),
			view.leadingAnchor.constraint(equalTo: leadingAnchor),
			view.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
}
