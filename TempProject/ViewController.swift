//
//  ViewController.swift
//  TempProject
//
//  Created by Scott Leonard on 5/28/20.
//  Copyright © 2020 DuhMarket. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	
	
	@IBOutlet var displayImage: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func didClickButton(sender: UIButton!) {
		CameraPresentationWrapper.createPresenterWith(viewController: self, completion: { image in
			self.displayImage.image = image
		})
	}
}

