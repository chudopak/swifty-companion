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
			setCoalitionData()
		}
	}
	
	private lazy var backgroundImageView = makeBackgroundImageView()
	private lazy var activityIndicator = makeActivityIndicator()
	private lazy var errorView = ErrorView(delegate: self)
	private lazy var scrollView = makeScrollView()
	private lazy var primaryUserInfoView = PrimaryUserInfoView()
	private lazy var primaryUserInfoBackgroundView = makePrimaryUserInfoBackgroundView()
	private lazy var locationInClasterView = LocationInClasterView()
	private lazy var levelView = LevelView()
	
	private var spaceBetweenViews: CGFloat = 15
	private lazy var refreshControll = makeRefreshControll()
	
	private lazy var test = makePrimaryUserInfoBackgroundView()
	
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
		
//		var previousLab : UILabel? = nil
//		for i in 0 ..< 30 {
//			let lab = UILabel()
//			lab.backgroundColor = .red
//			lab.translatesAutoresizingMaskIntoConstraints = false
//			lab.text = "T \(i+1)"
//			scrollView.addSubview(lab)
//			lab.leadingAnchor.constraint(
//				equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
//			lab.topAnchor.constraint(
//				// first one, pin to top; all others, pin to previous
//				equalTo: previousLab?.bottomAnchor ?? scrollView.topAnchor,
//				constant: 10).isActive = true
//			previousLab = lab
//		}
//		scrollView.bottomAnchor.constraint(
//				equalTo: previousLab!.bottomAnchor, constant: 10).isActive = true
//		test.trailingAnchor.constraint(
//				equalTo: scrollView.trailingAnchor).isActive = true
		scrollView.bottomAnchor.constraint(
						equalTo: test.bottomAnchor, constant: 10).isActive = true

		if (userData != nil) {
			showUserProfile()
		} else {
			getMyData()
		}
    }
	
	private func showUserProfile() {
		guard let userDataUnwrapped = userData else {
			errorView.errorDescription = "We are sorry :( Please reload app."
			changeViewsVisibility(profile: false, error: true)
			print("UserProfileViewController (showUserProfile) userData somehow nil")
			return
		}
		findCoalition(userId: String(userDataUnwrapped.id))
		primaryUserInfoView.primaryUserInfo = PrimaryUserInfo(userData: userDataUnwrapped)
		locationInClasterView.location = constructLocationInClasterText(location: userDataUnwrapped.location)
		levelView.levelInfo = LevelInfo(level: getUserLevel(cursus: userDataUnwrapped.cursus_users))
	}
	
	private func getMyData() {
		guard let url = createURLWithComponents(path: "/v2/me") else {
			errorView.errorDescription = "We are sorry :( Please reload app."
			changeViewsVisibility(profile: false, error: true)
			print("UserProfileViewController (viewDidLoad) - Can't create url")
			return
		}
		searchUser.fetchUserData(with: url)
	}
	
	private func setCoalitionData() {
		switch searchCoalitionStatus {
		case .initial:
			break
		case .success(let result):
			print(result.image_url)
			print(result.name)
			print(result.color)
			backgroundImageView.download(from: result.image_url, defaultImageName: "background", contentMode: .scaleToFill)
			levelView.levelInfo = LevelInfo(level: getUserLevel(cursus: userData?.cursus_users), color: result.color)
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
				self?.changeViewsVisibility(profile: false, error: false)
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
		changeViewsVisibility(profile: true, error: false)
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
		changeViewsVisibility(profile: false, error: true)
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
		//we don't hide errorView here because it will hide when loading starts
		getMyData()
	}
	
	private func changeViewsVisibility(profile: Bool = false, error: Bool = false) {
		errorView.isHidden = !error
		scrollView.isHidden = !profile
	}
	
	private func constructLocationInClasterText(location: String?) -> String {
		if let location = location {
			if (location != "") {
				return( """
						Available
						\(location)
						""")
			} else {
				return(	"""
						Unavailable
						-
						""")
			}
		}
		else {
			return ("""
					Unavailable
					-
					""")
		}
	}
	
	private func getUserLevel(cursus: [Cursus]?) -> Double {
		guard let cursus = cursus,
			  cursus.count != 0
		else {
			return (0.0)
		}
		return (cursus[cursus.count - 1].level)
	}
	
	@objc private func refreshUserData(sender: UIRefreshControl) {
		guard let userData = userData,
			  let url = URL(string: userData.url)
		else {
			print("Can't refresh page")
			return
		}
		searchUser.fetchUserData(with: url)
		refreshControll.endRefreshing()
	}
}

extension UserProfileViewController {
	
	private func setView() {
		view.addSubview(backgroundImageView)
		view.addSubview(activityIndicator)
		view.addSubview(scrollView)
		view.addSubview(errorView)
		errorView.isHidden = true
		scrollView.refreshControl = refreshControll
		scrollView.addSubview(primaryUserInfoBackgroundView)
		scrollView.addSubview(primaryUserInfoView)
		scrollView.addSubview(locationInClasterView)
		scrollView.addSubview(levelView)
		scrollView.addSubview(test)
		view.backgroundColor = .black
		navigationItem.title = userData?.login
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
	
	private func makeScrollView() -> UIScrollView {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		return (scrollView)
	}
	
	private func makePrimaryUserInfoBackgroundView() -> UIView {
		let v = UIView()
		v.translatesAutoresizingMaskIntoConstraints = false
		v.backgroundColor = UIColor(named: "UserInfoScreenBackgroundColor")
		v.layer.cornerRadius = backgroundCornerRadius
		return (v)
	}
	
	private func makeRefreshControll() -> UIRefreshControl {
		let control = UIRefreshControl()
		control.addTarget(self, action: #selector(refreshUserData(sender:)), for: .valueChanged)
		return (control)
	}
}

extension UserProfileViewController {
	
	private func setConstraints() {
		setActivityIndicatorConstraints(for: activityIndicator, superView: view)
		setErrorViewConstraints(for: errorView, superView: view)
		setScrollViewConstrsints(for: scrollView, superView: view)
		setPrimaryUserInfoViewConstraints(for: primaryUserInfoView, superView: scrollView)
		setBackgroundViewConstraints()
		setLocationInClasterViewConstraints(for: locationInClasterView)
		setLevelViewConstraints(for: levelView)
		setTest(for: test)
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
	
	private func setScrollViewConstrsints(for view: UIView, superView: UIView) {
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: superView.topAnchor),
			view.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
			view.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
			view.trailingAnchor.constraint(equalTo: superView.trailingAnchor)
		])
	}
	
	private func setPrimaryUserInfoViewConstraints(for view: UIView, superView: UIScrollView) {
//		let guide = superView.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
//			view.topAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
			view.topAnchor.constraint(equalTo: superView.topAnchor, constant: profileViewSideOffset),
			view.leadingAnchor.constraint(equalTo: superView.layoutMarginsGuide.leadingAnchor),
			view.trailingAnchor.constraint(equalTo: superView.layoutMarginsGuide.trailingAnchor),
			view.heightAnchor.constraint(equalToConstant: profileViewHeight)
		])
	}
	
	private func setBackgroundViewConstraints() {
		NSLayoutConstraint.activate([
			primaryUserInfoBackgroundView.heightAnchor.constraint(equalToConstant: primaryUserInfoBackgroundViewHeight),
			primaryUserInfoBackgroundView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
			primaryUserInfoBackgroundView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
			primaryUserInfoBackgroundView.bottomAnchor.constraint(equalTo: primaryUserInfoView.bottomAnchor, constant: profileViewSideOffset)
		])
	}
	
	private func setLocationInClasterViewConstraints(for view: UIView) {
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: primaryUserInfoBackgroundView.bottomAnchor, constant: spaceBetweenViews),
			view.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
			view.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
			view.heightAnchor.constraint(equalToConstant: locationInClasterViewHeight)
		])
	}
	
	private func setLevelViewConstraints(for view: UIView) {
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: locationInClasterView.bottomAnchor, constant: spaceBetweenViews),
			view.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
			view.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
			view.heightAnchor.constraint(equalToConstant: levelViewHeight)
		])
	}
	
	private func setTest(for view: UIView) {
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: levelView.bottomAnchor, constant: spaceBetweenViews),
			view.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
			view.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
			view.heightAnchor.constraint(equalToConstant: 1000)
		])
	}
}
