//
//  TabBar.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/23/22.
//

import UIKit

class TabBar: UITabBarController {

	private var searchUserViewModel: SearchUserViewModel!
	
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
