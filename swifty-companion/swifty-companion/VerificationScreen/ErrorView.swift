//
//  ErrorView.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/2/22.
//

import UIKit

class ErrorView: UIView {

	private weak var delegate: VerificationViewControllerDelegate!
	
	lazy var errorImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "xmark.circle")
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.tintColor = UIColor(named: "errorTintColorRed")
		return (imageView)
	}()
	
	lazy var errorLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.textAlignment = .center
		label.text = "Error"
		label.font = UIFont.boldSystemFont(ofSize: 22)
		label.adjustsFontSizeToFitWidth = true
		return (label)
	}()
	
	lazy var errorDescriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.textColor = UIColor(named: "errorTintColorGray")
		label.textAlignment = .center
		label.text = "Poor internet connection"
		label.font = UIFont.systemFont(ofSize: 16, weight: .light)
		label.adjustsFontSizeToFitWidth = true
		return (label)
	}()
	
	lazy var retryButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = UIColor(named: "errorButtonTintColorGray")
		button.layer.cornerRadius = 7
		button.clipsToBounds = true
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(retryTestRequest), for: .touchUpInside)
		button.addSubview(retryButtonLabel)
		return (button)
	}()
	
	lazy var retryButtonLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.textColor =  UIColor(named: "errorTintColorRed")
		label.text = "Try Again"
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 18)
		label.adjustsFontSizeToFitWidth = true
		return (label)
	}()
	
	init(delegate: VerificationViewControllerDelegate) {
		super.init(frame: CGRect.zero)
		self.delegate = delegate
		translatesAutoresizingMaskIntoConstraints = false
		addSubview(errorImageView)
		addSubview(retryButton)
		addSubview(errorLabel)
		addSubview(errorDescriptionLabel)
		setConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc private func retryTestRequest() {
		delegate.retryTestConnectionDelegate()
	}
}
