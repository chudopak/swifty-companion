//
//  TabBar.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/23/22.
//

import UIKit

class TabBar: UITabBarController {

	private var searchUserViewModel: SearchUserViewModel!
	private var userData: UserData?
	
	init(userData: UserData) {
		super.init(nibName: nil, bundle: nil)
		self.userData = userData
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
		
    }
	
	private func setupViewControllers() {
		
		searchUserViewModel = SearchUserViewModel()
		
		let searchUserVC = SearchUserViewController(viewModel: searchUserViewModel)
		
		searchUserVC.title = NSLocalizedString("Explore", comment: "")
		
		setViewControllers([searchUserVC], animated: false)
		
		guard let items = tabBar.items else {
			print("Failed to get tabBar items")
			return
		}
		
		items[0].image = UIImage(systemName: "magnifyingglass")
	}
    
}
