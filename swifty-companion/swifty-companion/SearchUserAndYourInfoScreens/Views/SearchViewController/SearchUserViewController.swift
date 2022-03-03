//
//  SearchUserViewController.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/23/22.
//

import UIKit

class SearchUserViewController: UIViewController {
	
	private var searchUserViewModel: SearchUserViewModelProtocol!
	
	private lazy var searchView = SearchView(searchUserViewModel: searchUserViewModel)
	
	init(viewModel: SearchUserViewModelProtocol) {
		super.init(nibName: nil, bundle: nil)
		searchUserViewModel = viewModel
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.addSubview(searchView)
		setConstraints()
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


//	@objc func getMe() {
//		let url = createURLWithComponents(path: "/v2/users/aa")
//		guard let url = url else {
//			print("Can't create URL")
//			return
//		}
//		var request = URLRequest(url: url)
//		request.httpMethod = "GET"
//		request.setValue("Bearer \(Token.accessToken!)", forHTTPHeaderField: "Authorization")
//		let sessions = URLSession.shared.dataTask(with: request) { data, response, error in
//			guard let response = response as? HTTPURLResponse else {
//				print("Failed reequest")
//				return
//			}
//			guard error == nil, let data = data else {
//				print("error or data nil")
//				return
//			}
//			print("data- ",data)
//			if let object = try? JSONDecoder().decode(User.self, from: data) {
//				print(object)
//			}
//		}
//		sessions.resume()
//	}
