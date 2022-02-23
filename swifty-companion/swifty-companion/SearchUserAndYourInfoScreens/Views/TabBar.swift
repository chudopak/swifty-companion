//
//  TabBar.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/23/22.
//

import UIKit

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
		setupViewControllers()
    }
	
	private func setupViewControllers() {
		let searchUserVC = SearchUserViewController()
		
		searchUserVC.title = NSLocalizedString("Explore", comment: "")
		
		setViewControllers([searchUserVC], animated: false)
		
		guard let items = tabBar.items else {
			print("Failed to get tabBar items")
			return
		}
		
		items[0].image = UIImage(systemName: "magnifyingglass")
	}
    
}
