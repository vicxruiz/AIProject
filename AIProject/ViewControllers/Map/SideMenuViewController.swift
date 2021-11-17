//
//  SideMenuViewController.swift
//  AIProject
//
//  Created by Victor Ruiz on 11/15/21.
//

import Foundation
import UIKit

class SideMenuViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		let gradient = CAGradientLayer()
		gradient.colors = [UIColor.white.cgColor, UIColor.black]
		gradient.frame = view.bounds
		view.layer.insertSublayer(gradient, at: 0)
	}
}
