//
//  SearchView+ViewItemsInitialisation.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/2/22.
//

import UIKit

extension SearchView {
	
	func makeBackgroundImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = UIImage(named: "background")
		imageView.isUserInteractionEnabled = true
		return (imageView)
	}
}
