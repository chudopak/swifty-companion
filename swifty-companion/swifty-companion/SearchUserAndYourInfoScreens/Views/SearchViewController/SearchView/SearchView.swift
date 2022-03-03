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
	private lazy var stackView = makeStackView()
	private lazy var searchButton = makeSearchButton()
	private lazy var searchBar = makeTextField()
	private lazy var errorView = ErrorView(delegate: self)
	private lazy var activityIndicator = makeActivityIndicator()
	
	
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
			makeVisible(stackView: true)
			print(userData)
		default:
			break
		}
	}
	
	private func makeVisible(stackView stackViewVisibility: Bool = false, errorViewVisibility: Bool = false) {
		errorView.isHidden = !errorViewVisibility
		stackView.isHidden = !stackViewVisibility
	}
	
	@objc private func startSearching() {
		let username = searchBar.text?.lowercased() ?? ""
		if username == "" {
			return
		}
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
	
	private func handleFailure(code: SearchUserStatus.FailCode) {
		switch code {
		case .networking:
			errorView.errorDescription = code.rawValue
			makeVisible(errorViewVisibility: true)
		case .userNotFound:
			//make custom UserNotFoundView
			errorView.errorDescription = code.rawValue
			makeVisible(errorViewVisibility: true)
		}
	}
	
	func retryFetchDelegate() {
		makeVisible(stackView: true)
	}
	
	private func setupViews() {
		translatesAutoresizingMaskIntoConstraints = false
		addSubview(backgroundImageView)
		backgroundImageView.addSubview(errorView)
		errorView.isHidden = true
		backgroundImageView.addSubview(stackView)
		backgroundImageView.addSubview(activityIndicator)
		stackView.addArrangedSubview(searchBar)
		stackView.addArrangedSubview(searchButton)
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
	
	private func makeSearchButton() -> UIButton {
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
		setStackViewConstraints(for: stackView, with: backgroundImageView)
		setErrorViewConstraints(for: errorView, with: backgroundImageView)
		setActivityIndicatorConstraints(for: activityIndicator, with: backgroundImageView)
	}
}
