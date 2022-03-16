//
//  ChartViewController.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/16/22.
//

import UIKit

class ChartViewController: UIViewController {

	let color = [
		UIColor.black,
		UIColor.green,
		UIColor.red,
		UIColor.blue
	]
	
	var index = 0
	
	init(i: Int) {
		super.init(nibName: nil, bundle: nil)
		index = i
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = color[index]
	}

}
