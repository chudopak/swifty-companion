//
//  VerificationViewController+Setups.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/2/22.
//
import UIKit

class VerificationViewController: UIViewController, ErrorViewDelegate {
	
	private lazy var backgroundImage: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "background")
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.isUserInteractionEnabled = true
		return imageView
	}()
	
	private lazy var activityIndicator: UIActivityIndicatorView = {
		let indic = UIActivityIndicatorView(style: .large)
		indic.hidesWhenStopped = true
		indic.translatesAutoresizingMaskIntoConstraints = false
		indic.color = UIColor(named: "buttonsGreen")
		return indic
	}()
	
	private lazy var sessionConfiguration = _setURLSessionConfiguration()
	private lazy var session = URLSession(configuration: sessionConfiguration)
	
	private lazy var errorView = ErrorView(delegate: self)
	
	private var attempts = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(backgroundImage)
		backgroundImage.addSubview(errorView)
		backgroundImage.addSubview(activityIndicator)
		errorView.isHidden = true
		setConstraints()
		activityIndicator.startAnimating()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if (Token.accessToken == nil || Token.refreshToken == nil) {
			presentLoginViewController()
			print("Presenting Login View Controller at first time")
			return
		}
		sendTestRequest()
	}
	
	private func sendTestRequest() {
		guard let url = createURLWithComponents(path: "/v2/me") else {
			print("Can't create url")
			activityIndicator.stopAnimating()
			showErrorView(errorDescription: "Something went wrong :_(")
			return
		}
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.get.rawValue
		request.setValue("Bearer \(Token.accessToken!)", forHTTPHeaderField: "Authorization")
		
		let testRequest = session.dataTask(with: request) { [weak self] data, response, error in
			
			DispatchQueue.main.async {
				self?.activityIndicator.stopAnimating()
			}
			guard let response = response as? HTTPURLResponse,
				  (200...299).contains(response.statusCode) || response.statusCode == 401
			else {
				let response = response as? HTTPURLResponse
				DispatchQueue.main.async {
					self?.showErrorView(errorDescription: "Poor internet connection")
				}
				print(response?.statusCode ?? 0, "HTTP request error")
				return
			}
			print("Verification response \(response.statusCode)")
			guard error == nil,
				  let data = data,
				  let object = try? JSONDecoder().decode(UserData.self, from: data)
			else {
				if (self?.attempts == 0) {
					self?.attempts += 1
					print("Attempts")
					self?.sendTestRequest()
				} else {
					Token.accessToken = nil
					Token.refreshToken = nil
					DispatchQueue.main.async {
						self?.presentLoginViewController()
					}
				}
				return
			}
			printData(data: object)
			DispatchQueue.main.async {
				self?.presentSearchUserScreen(userData: object)
			}
		}
		testRequest.resume()
	}
	
	private func presentSearchUserScreen(userData: UserData) {
		let tabBar = TabBar(userData: userData)
		tabBar.modalPresentationStyle = .fullScreen
		present(tabBar, animated: false, completion: nil)
	}
	
	private func presentLoginViewController() {
		let loginVC = LoginViewController()
		loginVC.modalPresentationStyle = .fullScreen
		present(loginVC, animated: false, completion: nil)
	}

	//MARK: Delegate
	func retryFetchDelegate() {
		errorView.isHidden = true
		activityIndicator.startAnimating()
		sendTestRequest()
	}
	
	private func showErrorView(errorDescription: String) {
		errorView.errorDescription = errorDescription
		errorView.isHidden = false
		activityIndicator.isHidden = true
	}
	
	private func _setURLSessionConfiguration() -> URLSessionConfiguration {
		let configuration = URLSessionConfiguration.default
		configuration.waitsForConnectivity = true
		configuration.timeoutIntervalForResource = 30
		return (configuration)
	}
}

extension VerificationViewController {
	
	private func setBackgroundImageConstraints() {
		NSLayoutConstraint.activate([
			backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
			backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
			backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor)
		])
	}
	
	private func setActivityIndicatorConstraints() {
		NSLayoutConstraint.activate([
			activityIndicator.centerYAnchor.constraint(equalTo: backgroundImage.centerYAnchor),
			activityIndicator.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor),
			activityIndicator.heightAnchor.constraint(equalToConstant: activityIndicatorSize),
			activityIndicator.widthAnchor.constraint(equalToConstant: activityIndicatorSize)
		])
	}
	
	private func setErrorViewConstraints() {
		NSLayoutConstraint.activate([
			errorView.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor),
			errorView.centerYAnchor.constraint(equalTo: backgroundImage.centerYAnchor),
			errorView.heightAnchor.constraint(equalToConstant: errorViewHeight),
			errorView.widthAnchor.constraint(equalToConstant: errorViewWidth)
		])
	}
	
	private func setConstraints() {
		setBackgroundImageConstraints()
		setActivityIndicatorConstraints()
		setErrorViewConstraints()
	}
}
