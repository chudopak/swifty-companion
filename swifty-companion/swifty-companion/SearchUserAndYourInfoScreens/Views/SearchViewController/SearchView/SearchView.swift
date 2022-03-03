//
//  SearchView.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/2/22.
//

import UIKit

class SearchView: UIView, UITextFieldDelegate {

	private var searchUserViewModel: SearchUserViewModelProtocol! {
		didSet {
			
		}
	}
	
	private var searchUserStatus: SearchUserStatus = SearchUserStatus.initial
	
	private lazy var backgroundImageView = makeBackgroundImageView()
	private lazy var stackView = makeStackView()
	private lazy var searchButton = makeSearchButton()
	private lazy var searchBar = makeTextField()
	
	init(searchUserViewModel: SearchUserViewModelProtocol) {
		super.init(frame: CGRect.zero)
		self.searchUserViewModel = searchUserViewModel
		self.searchUserViewModel.updateUserData = { [weak self] status in
			self?.searchUserStatus = status
		}
		translatesAutoresizingMaskIntoConstraints = false
		addSubview(backgroundImageView)
		backgroundImageView.addSubview(stackView)
		stackView.addArrangedSubview(searchBar)
		stackView.addArrangedSubview(searchButton)
		setConstraints()
		
		let hideKeyboardGuesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
		hideKeyboardGuesture.cancelsTouchesInView = false
		addGestureRecognizer(hideKeyboardGuesture)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc private func hideKeyboard(_ guestureRecognizer: UIGestureRecognizer) {
		searchBar.resignFirstResponder()
	}
}

extension SearchView {
	
	private func makeBackgroundImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = UIImage(named: "background")
		imageView.isUserInteractionEnabled = true
		return (imageView)
	}
	
	private func makeStackView() -> UIStackView {
		let view = UIStackView()
		view.axis = .vertical
		view.distribution = .fillEqually
		view.spacing = stackViewSpacing
		view.translatesAutoresizingMaskIntoConstraints = false
		return (view)
	}
	
	private func makeSearchButton() -> UIButton {
		let searchButton = GreenButton()
		searchButton.setTitle("Search", for: .normal)
		searchButton.backgroundColor = UIColor(named: "buttonsGreen")
		searchButton.layer.cornerRadius = buttonCornerRadius
		searchButton.translatesAutoresizingMaskIntoConstraints = false
		return (searchButton)
	}
	
	private func makeTextField() -> UITextField {
		let textField = UITextField()
		textField.attributedPlaceholder = NSAttributedString(string: "Enter username",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.delegate = self
		textField.backgroundColor = UIColor(named: "textFieldBackground")
		textField.borderStyle = .roundedRect
		textField.textAlignment = .left
		textField.autocapitalizationType = .none
		textField.layer.borderWidth = searchBarBoarderWidth
		textField.layer.cornerRadius = searchBarCornerRadius
		textField.layer.borderColor = UIColor(named: "buttonsGreen")?.cgColor
		textField.textColor = .white
		textField.autocorrectionType = .no
		textField.keyboardType = .default
		textField.returnKeyType = .search
		
		
		return (textField)
	}
}

extension SearchView {
	
	private func setBackgroudConstraints(for view: UIView) {
		NSLayoutConstraint.activate([
			view.leftAnchor.constraint(equalTo: leftAnchor),
			view.rightAnchor.constraint(equalTo: rightAnchor),
			view.topAnchor.constraint(equalTo: topAnchor),
			view.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
	
	private func setStackViewConstraints(for view: UIView, with superView: UIView) {
		NSLayoutConstraint.activate([
			view.centerYAnchor.constraint(equalTo: superView.centerYAnchor),
			view.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
			view.heightAnchor.constraint(equalToConstant: stackViewHeight),
			view.widthAnchor.constraint(equalToConstant: stackViewWidht)
		])
	}
	
	private func setConstraints() {
		setBackgroudConstraints(for: backgroundImageView)
		setStackViewConstraints(for: stackView, with: backgroundImageView)
	}
}
