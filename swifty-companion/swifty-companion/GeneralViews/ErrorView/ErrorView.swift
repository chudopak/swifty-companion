//
//  ErrorView.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/2/22.
//

import UIKit

protocol ErrorViewDelegate: AnyObject {
	func retryFetchDelegate()
}

class ErrorView: UIView {

	lazy var errorDescription: String = "" {
		didSet {
			errorDescriptionLabel.text = errorDescription
			setNeedsLayout()
		}
	}
	
	private weak var delegate: ErrorViewDelegate!
	
	private lazy var errorImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "xmark.circle")
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.tintColor = UIColor(named: "errorTintColorRed")
		return (imageView)
	}()
	
	private lazy var errorLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.textAlignment = .center
		label.text = "Error"
		label.font = UIFont.boldSystemFont(ofSize: 22)
		label.adjustsFontSizeToFitWidth = true
		return (label)
	}()
	
	private lazy var errorDescriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.textColor = UIColor(named: "errorTintColorGray")
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 16, weight: .light)
		label.adjustsFontSizeToFitWidth = true
		return (label)
	}()
	
	private lazy var retryButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = UIColor(named: "errorButtonTintColorGray")
		button.layer.cornerRadius = 7
		button.clipsToBounds = true
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(retryTestRequest), for: .touchUpInside)
		button.addSubview(retryButtonLabel)
		return (button)
	}()
	
	private lazy var retryButtonLabel: UILabel = {
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
	
	init(delegate: ErrorViewDelegate) {
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
		delegate.retryFetchDelegate()
	}
}

extension ErrorView {

	private func setErrorImageViewConstraints() {
		NSLayoutConstraint.activate([
			errorImageView.topAnchor.constraint(equalTo: topAnchor),
			errorImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			errorImageView.heightAnchor.constraint(equalToConstant: errorImageViewHeight),
			errorImageView.widthAnchor.constraint(equalToConstant: errorImageViewWidth)
		])
	}
	
	private func setErrorLabelConstraints() {
		NSLayoutConstraint.activate([
			errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: errorViewEmptyHeightSpace * 0.1),
			errorLabel.rightAnchor.constraint(equalTo: rightAnchor),
			errorLabel.leftAnchor.constraint(equalTo: leftAnchor),
			errorLabel.heightAnchor.constraint(equalToConstant: errorLabelHeight)
		])
	}
	
	private func setErrorDescriptionLabel() {
		NSLayoutConstraint.activate([
			errorDescriptionLabel.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: errorViewEmptyHeightSpace * 0.1),
			errorDescriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
			errorDescriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
			errorDescriptionLabel.heightAnchor.constraint(equalToConstant: errorDesctiptionLabelHeight)
		])
	}
	
	private func setRetryButtonConstraints() {
		NSLayoutConstraint.activate([
			retryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -errorViewEmptyHeightSpace * 0.5),
			retryButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
			retryButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
			retryButton.heightAnchor.constraint(equalToConstant: errorRetryButtonHeight)
		])
	}
	
	private func setRetryButtonLabelConstraints() {
		NSLayoutConstraint.activate([
			retryButtonLabel.topAnchor.constraint(equalTo: retryButton.topAnchor),
			retryButtonLabel.bottomAnchor.constraint(equalTo: retryButton.bottomAnchor),
			retryButtonLabel.rightAnchor.constraint(equalTo: retryButton.rightAnchor),
			retryButtonLabel.leftAnchor.constraint(equalTo: retryButton.leftAnchor)
		])
	}
	
	private func setConstraints() {
		setErrorImageViewConstraints()
		setErrorLabelConstraints()
		setErrorDescriptionLabel()
		setRetryButtonConstraints()
		setRetryButtonLabelConstraints()
	}
}
