//
//  SplashScreenViewController.swift
//  AIProject
//
//  Created by Victor Ruiz on 11/15/21.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class splashScreenController: UIViewController {
  
	fileprivate func checkLoggedInUserStatus() {
		//checking for current user
		//if no current user present welcome navigation controlller
		if Auth.auth().currentUser == nil {
			DispatchQueue.main.async {
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let vc = storyboard.instantiateViewController(withIdentifier: "idMyViewControllerName") as! WelcomeNavigationController
				vc.modalPresentationStyle = .fullScreen
				self.present(vc, animated: false, completion: nil)
			}
		}
	}
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// splashscreen for delay of 2, then goes to home
		checkLoggedInUserStatus()
		perform(#selector(splashScreenController.showmainmenu), with: nil, afterDelay: 2)
	}
	
  
	// go to home screen of app
	@objc func showmainmenu(){
		// after delay shows home
		performSegue(withIdentifier: "home", sender: self)
	}
	
}

class WelcomeNavigationController: UINavigationController {
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}
