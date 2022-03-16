//
//  TabBar.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/23/22.
//

import UIKit

class TabBar: UITabBarController {

	private var searchUserViewModel: SearchDataViewModel!
	private var userData: UserData?
	
	init(userData: UserData) {
		self.userData = userData
		super.init(nibName: nil, bundle: nil)
	}
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupViewControllers()
		tabBar.barTintColor = UIColor(named: "barsColor")
		tabBar.tintColor = UIColor(named: "barsTintColor")
    }
	
	private func setupViewControllers() {
		
		let searchUserVC = SearchUserViewController()
		let userProfileVC: UserProfileViewController
		if let userData = userData {
			userProfileVC = UserProfileViewController(userData: userData)
		} else {
			userProfileVC = UserProfileViewController()
		}
		
		searchUserVC.title = NSLocalizedString("Explore", comment: "")
		userProfileVC.title = NSLocalizedString("Home", comment: "")
		
		setViewControllers([searchUserVC, userProfileVC], animated: false)
		
		guard let items = tabBar.items else {
			fatalError("Failed to get tabBar items")
		}
		
		items[0].image = UIImage(systemName: "magnifyingglass")
		items[1].image = UIImage(systemName: "house")
	}
    
}
