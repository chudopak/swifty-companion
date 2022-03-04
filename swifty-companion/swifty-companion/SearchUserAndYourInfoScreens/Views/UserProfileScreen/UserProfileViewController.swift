//
//  UserInfoViewController.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/28/22.
//

import UIKit

class UserProfileViewController: UIViewController {

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
		setNetworkClosures()
		findCoalition(userId: String(userData!.id))
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .black
		view.addSubview(backgroundImageView)
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
		setConstraints()
    }
	
	private func setCoalitionImage() {
		switch searchCoalitionStatus {
		case .initial:
			break
		case .success(let result):
			print(result.image_url)
			backgroundImageView.download(from: result.image_url, defaultImageName: "background", contentMode: .scaleToFill)
		case .failure:
			backgroundImageView.image = UIImage(named: "background")
		}
	}
	
	private func findCoalition(userId: String) {
		guard let url = createURLWithComponents(path: "/v2/users/\(userId)/coalitions") else {
			print("Can't create url")
			return
		}
		searchCoalition.fetchCoalitionData(with: url)
	}
	
	@objc func close() {
		dismiss(animated: true, completion: nil)
	}
}

extension UserProfileViewController {
	
	private func setNetworkProtocols() {
		let searchDataViewModel = SearchDataViewModel()
		searchCoalition = searchDataViewModel as SearchCoalitionProtocol
		searchUser = searchDataViewModel as SearchUserProtocol
	}
	
	private func setNetworkClosures() {
		searchCoalition.updateCoalitionData = { [weak self] data in
			self?.searchCoalitionStatus = data
		}
	}
	
	private func makeBackgroundImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.isUserInteractionEnabled = true
		return (imageView)
	}
}

extension UserProfileViewController {
	
	private func setConstraints() {
		setBackgroudConstraints(for: backgroundImageView)
	}
	
	private func setBackgroudConstraints(for background: UIView) {
		NSLayoutConstraint.activate([
			background.leftAnchor.constraint(equalTo: view.leftAnchor),
			background.rightAnchor.constraint(equalTo: view.rightAnchor),
			background.topAnchor.constraint(equalTo: view.topAnchor),
			background.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}
