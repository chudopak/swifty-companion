//
//  SearchUserViewController.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/23/22.
//

import UIKit

protocol SearchUserViewControllerDelegate: AnyObject {
	func openUserProfileViewController(userData: UserData)
	func signOutUnathorized()
}

class SearchUserViewController: UIViewController, SearchUserViewControllerDelegate {
	
	private lazy var searchUserViewModel = SearchDataViewModel()
	
	private lazy var searchView = SearchView(searchUserViewModel: searchUserViewModel, delegate: self)
	
    override func viewDidLoad() {
		view.isOpaque = false
        super.viewDidLoad()
		view.addSubview(searchView)
		setConstraints()
    }
	
	internal func openUserProfileViewController(userData: UserData) {
		let userProfileVC = UserProfileViewController(userData: userData)
		userProfileVC.modalPresentationStyle = .fullScreen
		let navController = UINavigationController(rootViewController: userProfileVC)
		navController.modalPresentationStyle = .fullScreen
		navController.navigationBar.barTintColor = UIColor(named: "barsColor")
		navController.navigationBar.tintColor = UIColor(named: "buttonsGreen")
		navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		present(navController, animated: true, completion: nil)
	}
	
	func signOutUnathorized() {
		Token.accessToken = nil
		Token.refreshToken = nil
		let loginVC = LoginViewController()
		loginVC.modalPresentationStyle = .fullScreen
		present(loginVC, animated: false, completion: nil)
	}
}

extension SearchUserViewController {
	
	func setConstraints() {
		NSLayoutConstraint.activate([
			searchView.topAnchor.constraint(equalTo: view.topAnchor),
			searchView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			searchView.rightAnchor.constraint(equalTo: view.rightAnchor),
			searchView.leftAnchor.constraint(equalTo: view.leftAnchor)
		])
	}
}
