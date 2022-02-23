//
//  SearchUserViewController.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 2/23/22.
//

import UIKit

class SearchUserViewController: UIViewController {

	lazy var helloLabel: UILabel = {
		let label = UILabel()
		label.bounds.size = CGSize(width: 200, height: 50)
		label.text = "Hello yo"
		return label
	}()
    override func viewDidLoad() {
        super.viewDidLoad()
		view.addSubview(helloLabel)
		helloLabel.center = view.center
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
}
