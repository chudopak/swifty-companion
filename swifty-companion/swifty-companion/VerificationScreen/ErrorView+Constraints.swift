//
//  ErrorView+Constraints.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/2/22.
//

import UIKit

extension ErrorView {

	func setErrorImageViewConstraints() {
		NSLayoutConstraint.activate([
			errorImageView.topAnchor.constraint(equalTo: topAnchor),
			errorImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			errorImageView.heightAnchor.constraint(equalToConstant: errorImageViewHeight),
			errorImageView.widthAnchor.constraint(equalToConstant: errorImageViewWidth)
		])
	}
	
	func setErrorLabelConstraints() {
		NSLayoutConstraint.activate([
			errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: errorViewEmptyHeightSpace * 0.1),
			errorLabel.rightAnchor.constraint(equalTo: rightAnchor),
			errorLabel.leftAnchor.constraint(equalTo: leftAnchor),
			errorLabel.heightAnchor.constraint(equalToConstant: errorLabelHeight)
		])
	}
	
	func setErrorDescriptionLabel() {
		NSLayoutConstraint.activate([
			errorDescriptionLabel.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: errorViewEmptyHeightSpace * 0.1),
			errorDescriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
			errorDescriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
			errorDescriptionLabel.heightAnchor.constraint(equalToConstant: errorDesctiptionLabelHeight)
		])
	}
	
	func setRetryButtonConstraints() {
		NSLayoutConstraint.activate([
			retryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -errorViewEmptyHeightSpace * 0.5),
			retryButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
			retryButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
			retryButton.heightAnchor.constraint(equalToConstant: errorRetryButtonHeight)
		])
	}
	
	func setRetryButtonLabelConstraints() {
		NSLayoutConstraint.activate([
			retryButtonLabel.topAnchor.constraint(equalTo: retryButton.topAnchor),
			retryButtonLabel.bottomAnchor.constraint(equalTo: retryButton.bottomAnchor),
			retryButtonLabel.rightAnchor.constraint(equalTo: retryButton.rightAnchor),
			retryButtonLabel.leftAnchor.constraint(equalTo: retryButton.leftAnchor)
		])
	}
	
	func setConstraints() {
		setErrorImageViewConstraints()
		setErrorLabelConstraints()
		setErrorDescriptionLabel()
		setRetryButtonConstraints()
		setRetryButtonLabelConstraints()
	}
}
