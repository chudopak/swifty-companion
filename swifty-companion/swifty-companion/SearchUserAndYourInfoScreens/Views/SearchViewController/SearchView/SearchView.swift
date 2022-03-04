//
//  SearchView.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/2/22.
//

import UIKit

class SearchView: UIView, UITextFieldDelegate, ErrorViewDelegate {

	private var searchUserViewModel: SearchUserViewModelProtocol!
	
	private var searchUserStatus: SearchUserStatus = SearchUserStatus.initial {
		didSet {
			updateView()
			setNeedsLayout()
		}
	}
	
	private lazy var backgroundImageView = makeBackgroundImageView()
	private lazy var searchStackView = makeStackView()
	private lazy var searchButton = makeSearchButton()
	private lazy var searchBar = makeTextField()
	private lazy var errorView = ErrorView(delegate: self)
	private lazy var activityIndicator = makeActivityIndicator()
	private lazy var userNotFoundStackView = makeStackView()
	private lazy var tryAgainButtonn = makeTryAgainButton()
	private lazy var userNotFoundLabel = makeUserNotFoundLabel()
	
	private var lastSearchedUser = ""
	
	init(searchUserViewModel: SearchUserViewModelProtocol) {
		super.init(frame: CGRect.zero)
		self.searchUserViewModel = searchUserViewModel
		self.searchUserViewModel.updateUserData = { [weak self] status in
			self?.searchUserStatus = status
		}
		setupViews()
		setGestures()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	private func updateView() {
		switch searchUserStatus {
		case .loading:
			print("loading")
			activityIndicator.startAnimating()
			makeVisible()
		case .failure(let code):
			activityIndicator.stopAnimating()
			handleFailure(code: code)
		case .success(let userData):
			activityIndicator.stopAnimating()
			makeVisible(searchStackView: true)
			print(userData)
		default:
			break
		}
	}
	
	private func makeVisible(searchStackView stackViewVisibility: Bool = false,
							 errorViewVisibility: Bool = false,
							 userNotFoundStackView userNotFoundVisibility: Bool = false) {
		errorView.isHidden = !errorViewVisibility
		searchStackView.isHidden = !stackViewVisibility
		userNotFoundStackView.isHidden = !userNotFoundVisibility
	}
	
	private func handleFailure(code: SearchUserStatus.FailCode) {
		switch code {
		case .networking:
			errorView.errorDescription = code.rawValue
			makeVisible(errorViewVisibility: true)
		case .userNotFound:
			if lastSearchedUser.count > 13 {
				let cut = lastSearchedUser.prefix(10) + "..."
				userNotFoundLabel.text = "User \"\(cut)\" not found."
			} else {
				userNotFoundLabel.text = "User \"\(lastSearchedUser)\" not found."
			}
			makeVisible(userNotFoundStackView: true)
		}
	}
	
	@objc private func startSearching() {
		let username = searchBar.text?.lowercased() ?? ""
		if username == "" {
			return
		}
		lastSearchedUser = username
		guard let url = createURLWithComponents(path: "/v2/users/\(username)") else {
			errorView.errorDescription = "Unexpected error. We are sorry :("
			makeVisible(errorViewVisibility: true)
			return
		}
		searchUserViewModel.fetchUserData(with: url)
	}
	
	@objc private func hideKeyboard(_ guestureRecognizer: UIGestureRecognizer) {
		searchBar.resignFirstResponder()
	}
	
	@objc private func tryAgainFindUser() {
		makeVisible(searchStackView: true)
	}
	
	func retryFetchDelegate() {
		makeVisible(searchStackView: true)
	}
	
	private func setupViews() {
		translatesAutoresizingMaskIntoConstraints = false
		addSubview(backgroundImageView)
		backgroundImageView.addSubview(errorView)
		errorView.isHidden = true
		backgroundImageView.addSubview(activityIndicator)

		backgroundImageView.addSubview(searchStackView)
		searchStackView.addArrangedSubview(searchBar)
		searchStackView.addArrangedSubview(searchButton)
		
		backgroundImageView.addSubview(userNotFoundStackView)
		userNotFoundStackView.addArrangedSubview(userNotFoundLabel)
		userNotFoundStackView.addArrangedSubview(tryAgainButtonn)
		userNotFoundStackView.isHidden = true
		setConstraints()
	}
	
	private func setGestures() {
		let hideKeyboardGuesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
		hideKeyboardGuesture.cancelsTouchesInView = false
		addGestureRecognizer(hideKeyboardGuesture)
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
	
	private func makeActivityIndicator() -> UIActivityIndicatorView {
		let indic = UIActivityIndicatorView(style: .large)
		indic.hidesWhenStopped = true
		indic.translatesAutoresizingMaskIntoConstraints = false
		indic.color = UIColor(named: "buttonsGreen")
		return (indic)
	}
	
	private func makeStackView() -> UIStackView {
		let view = UIStackView()
		view.axis = .vertical
		view.distribution = .fillEqually
		view.spacing = stackViewSpacing
		view.translatesAutoresizingMaskIntoConstraints = false
		return (view)
	}

	private func makeTryAgainButton() -> GreenButton {
		let button = GreenButton()
		button.setTitle("Try Again", for: .normal)
		button.backgroundColor = UIColor(named: "buttonsGreen")
		button.layer.cornerRadius = buttonCornerRadius
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(tryAgainFindUser), for: .touchUpInside)
		return button
	}
	
	private func makeUserNotFoundLabel() -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.textColor = .white
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		label.adjustsFontSizeToFitWidth = true
		return (label)
	}
	
	private func makeSearchButton() -> GreenButton {
		let searchButton = GreenButton()
		searchButton.setTitle("Search", for: .normal)
		searchButton.backgroundColor = UIColor(named: "buttonsGreen")
		searchButton.layer.cornerRadius = buttonCornerRadius
		searchButton.translatesAutoresizingMaskIntoConstraints = false
		searchButton.addTarget(self, action: #selector(startSearching), for: .touchUpInside)
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
		textField.addTarget(self, action: #selector(startSearching), for: .editingDidEndOnExit)
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
	
	private func setErrorViewConstraints(for view: UIView, with superView: UIView) {
		NSLayoutConstraint.activate([
			view.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
			view.centerYAnchor.constraint(equalTo: superView.centerYAnchor),
			view.heightAnchor.constraint(equalToConstant: errorViewHeight),
			view.widthAnchor.constraint(equalToConstant: errorViewWidth)
		])
	}
	
	private func setActivityIndicatorConstraints(for view: UIView, with superView: UIView) {
		NSLayoutConstraint.activate([
			view.centerYAnchor.constraint(equalTo: superView.centerYAnchor),
			view.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
			view.heightAnchor.constraint(equalToConstant: 50),
			view.widthAnchor.constraint(equalToConstant: 50)
		])
	}
	
	private func setConstraints() {
		setBackgroudConstraints(for: backgroundImageView)
		setStackViewConstraints(for: searchStackView, with: backgroundImageView)
		setStackViewConstraints(for: userNotFoundStackView, with: backgroundImageView)
		setErrorViewConstraints(for: errorView, with: backgroundImageView)
		setActivityIndicatorConstraints(for: activityIndicator, with: backgroundImageView)
	}
}
