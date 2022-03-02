//
//  VerificationViewController.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/2/22.
//

import UIKit

class VerificationViewController: UIViewController {
	
	private lazy var backgroundImage: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "background")
		return imageView
	}()
	
	private lazy var activityIndicator: UIActivityIndicatorView = {
		let indic = UIActivityIndicatorView(style: .large)
		indic.hidesWhenStopped = true
		indic.color = UIColor(named: "buttonsGreen")
		return indic
	}()
	
	lazy var sessionConfiguration = _setURLSessionConfiguration()
	lazy var session = URLSession(configuration: sessionConfiguration)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		if (Token.accessToken == nil || Token.refreshToken == nil) {
			presentLoginViewController()
			return
		}
		sendTestRequest()
		view.addSubview(backgroundImage)
		backgroundImage.addSubview(activityIndicator)
		setConstraints()
		activityIndicator.startAnimating()
    }
	
	private func sendTestRequest() {
		guard let url = createURLWithComponents(path: "/v2/me") else {
			//show error view
			print("Can't create url")
			activityIndicator.stopAnimating()
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.get.rawValue
		request.setValue("Bearer \(Token.accessToken!)", forHTTPHeaderField: "Authorization")
		
		let testRequest = session.dataTask(with: request) { [weak self] data, response, error in
			
			self?.activityIndicator.stopAnimating()
			guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
				//show error view
				print("HTTP request error")
				return
			}
			guard error == nil,
				  let data = data,
				  let object = try? JSONDecoder().decode(UserData.self, from: data)
			else {
				DispatchQueue.main.async {
					self?.presentLoginViewController()
				}
				return
			}
			print(object)
			DispatchQueue.main.async {
				self?.presentSearchUserScreen()
			}
		}
		testRequest.resume()
	}
	
	func presentSearchUserScreen() {
		let tabBar = TabBar()
		tabBar.modalPresentationStyle = .fullScreen
		present(tabBar, animated: false, completion: nil)
	}
	
	func presentLoginViewController() {
		let loginVC = LoginViewController()
		loginVC.modalPresentationStyle = .fullScreen
		present(loginVC, animated: false, completion: nil)
	}
	
	private func _setURLSessionConfiguration() -> URLSessionConfiguration {
		let configuration = URLSessionConfiguration.default
		configuration.waitsForConnectivity = true
		configuration.timeoutIntervalForResource = 30
		return (configuration)
	}
	
	private func setConstraints() {
		NSLayoutConstraint.activate([
			backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
			backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
			backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor)
		])
		
		NSLayoutConstraint.activate([
			activityIndicator.centerYAnchor.constraint(equalTo: backgroundImage.centerYAnchor),
			activityIndicator.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor),
			activityIndicator.heightAnchor.constraint(equalToConstant: 50),
			activityIndicator.widthAnchor.constraint(equalToConstant: 50)
		])
	}
}
