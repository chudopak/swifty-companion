//
//  UserInfoViewController.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/28/22.
//

import UIKit

class UserProfileViewController: UIViewController, ErrorViewDelegate {

	private var userData: UserData?
	private var searchUser: SearchUserProtocol!
	private var searchCoalition: SearchCoalitionProtocol!
	private var coalitionData: CoalitionData?
	private var searchCoalitionStatus = SearchCoalitionStatus.initial {
		didSet {
			setCoalitionImage()
		}
	}
	
	private lazy var backgroundImageView = makeBackgroundImageView()
	private lazy var activityIndicator = makeActivityIndicator()
	private lazy var errorView = ErrorView(delegate: self)
	
	init() {
		super.init(nibName: nil, bundle: nil)
		setNetworkProtocols()
	}
	
	init(userData: UserData) {
		super.init(nibName: nil, bundle: nil)
		self.userData = userData
		setNetworkProtocols()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setView()
		setNetworkClosures()
		setConstraints()
		if (userData != nil) {
			showUserProfile()
		} else {
			getMyData()
		}
    }
	
	private func showUserProfile() {
		guard let userDataUnwrapped = userData else {
			errorView.errorDescription = "We are sorry :( Please reload app."
			isProfileVisible(to: false)
			print("UserProfileViewController (showUserProfile) userData somehow nil")
			return
		}
		findCoalition(userId: String(userDataUnwrapped.id))
	}
	
	private func setCoalitionImage() {
		switch searchCoalitionStatus {
		case .initial:
			break
		case .success(let result):
			print(result.image_url)
			print(result.name)
			backgroundImageView.download(from: result.image_url, defaultImageName: "background", contentMode: .scaleToFill)
		case .failure:
			print("UserProfileViewController - can't load coalition background")
		}
	}
	
	private func setNetworkClosures() {
		searchCoalition.updateCoalitionData = { [weak self] data in
			self?.searchCoalitionStatus = data
		}
		searchUser.updateUserData = { [weak self] data in
			switch data {
			case .loading:
				self?.isProfileVisible(to: true)
				self?.activityIndicator.startAnimating()
				print("Loading")
			case .success(let uData):
				self?.searchUserSuccessCase(uData: uData)
			case .failure(let code):
				self?.searchUserFailureCase(code: code)
			default: break
			}
		}
	}
	
	private func searchUserSuccessCase(uData: UserData) {
		userData = uData
		activityIndicator.stopAnimating()
		isProfileVisible(to: true)
		showUserProfile()
	}
	
	private func searchUserFailureCase(code: SearchUserStatus.FailCode) {
		activityIndicator.stopAnimating()
		switch code {
		case .userNotFound:
			errorView.errorDescription = "We Sorry :("
		case .networking:
			errorView.errorDescription = code.rawValue
		}
		isProfileVisible(to: false)
		print(code.rawValue)
	}
	
	private func findCoalition(userId: String) {
		guard let url = createURLWithComponents(path: "/v2/users/\(userId)/coalitions") else {
			print("UserProfileViewController (findCoalition) - Can't create url")
			return
		}
		searchCoalition.fetchCoalitionData(with: url)
	}
	
	@objc func close() {
		dismiss(animated: true, completion: nil)
	}
	
	func retryFetchDelegate() {
		//we doesn't hide errorView here because it will hide when loading starts
		getMyData()
	}
	
	private func isProfileVisible(to value: Bool) {
		errorView.isHidden = value
	}
	
	private func getMyData() {
		guard let url = createURLWithComponents(path: "/v2/me") else {
			errorView.errorDescription = "We are sorry :( Please reload app."
			isProfileVisible(to: false)
			print("UserProfileViewController (viewDidLoad) - Can't create url")
			return
		}
		searchUser.fetchUserData(with: url)
	}
}

extension UserProfileViewController {
	
	private func setView() {
		view.addSubview(backgroundImageView)
		view.addSubview(activityIndicator)
		view.addSubview(errorView)
		errorView.isHidden = true
		view.backgroundColor = .black
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
	}
	
	private func setNetworkProtocols() {
		let searchDataViewModel = SearchDataViewModel()
		searchCoalition = searchDataViewModel as SearchCoalitionProtocol
		searchUser = searchDataViewModel as SearchUserProtocol
	}
	
	private func makeBackgroundImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.isUserInteractionEnabled = true
		imageView.bounds.size.width = view.bounds.size.height
		imageView.bounds.size.height = view.bounds.size.width
		imageView.center = view.center
		imageView.transform = CGAffineTransform(rotationAngle: .pi / 2)
		imageView.image = UIImage(named: "backgroundLandscape")
		return (imageView)
	}
	
	private func makeActivityIndicator() -> UIActivityIndicatorView {
		let indic = UIActivityIndicatorView(style: .large)
		indic.hidesWhenStopped = true
		indic.translatesAutoresizingMaskIntoConstraints = false
		indic.color = UIColor(named: "buttonsGreen")
		return (indic)
	}
}

extension UserProfileViewController {
	
	private func setConstraints() {
		setActivityIndicatorConstraints(for: activityIndicator, superView: view)
		setErrorViewConstraints(for: errorView, superView: view)
	}
	
	private func setActivityIndicatorConstraints(for view: UIView, superView: UIView) {
		NSLayoutConstraint.activate([
			view.centerYAnchor.constraint(equalTo: superView.centerYAnchor),
			view.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
			view.heightAnchor.constraint(equalToConstant: activityIndicatorSize),
			view.widthAnchor.constraint(equalToConstant: activityIndicatorSize)
		])
	}
	
	private func setErrorViewConstraints(for view: UIView, superView: UIView) {
		NSLayoutConstraint.activate([
			view.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
			view.centerYAnchor.constraint(equalTo: superView.centerYAnchor),
			view.heightAnchor.constraint(equalToConstant: errorViewHeight),
			view.widthAnchor.constraint(equalToConstant: errorViewWidth)
		])
	}
}
