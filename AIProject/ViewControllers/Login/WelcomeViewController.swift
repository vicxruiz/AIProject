//
//  WelcomeViewController.swift
//  AIProject
//
//  Created by Victor Ruiz on 11/10/21.
//

import Foundation
import UIKit
import JGProgressHUD
import FirebaseStorage
import FirebaseDatabase
import Firebase
import FirebaseAuth

//updates nav bar for clear background
struct System {
	static func clearNavigationBar(forBar navBar: UINavigationBar) {
		navBar.setBackgroundImage(UIImage(), for: .default)
		navBar.shadowImage = UIImage()
		navBar.isTranslucent = true
	}
}

class WelcomeController: UIViewController {
	//Properties
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var signUpButton: UIButton!
	var name: String?
	var email: String?
	var phoneNumber: String?
	
	//shows indicator sign
	let hud: JGProgressHUD = {
		let hud = JGProgressHUD(style: .dark)
		hud.interactionType = .blockAllTouches
		return hud
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateNavBar()
		updateButtonViews()
	}
	
	//MARK: Actions
	
	@IBAction func loginButtonPressed(_ sender: Any) {
		performSegue(withIdentifier: "signIn", sender: self)
	}
	
	@IBAction func signUpButtonPressed(_ sender: Any) {
		performSegue(withIdentifier: "signUp", sender: self)
	}
}

//MARK: - Setup Views
extension WelcomeController {
	func updateButtonViews() {
		loginButton.layer.masksToBounds = true
		loginButton.layer.cornerRadius = Service.buttonCornerRadius
		signUpButton.layer.masksToBounds = true
		signUpButton.layer.cornerRadius = Service.buttonCornerRadius
	}
	
	func updateNavBar() {
		navigationController?.navigationBar.prefersLargeTitles = true
		
		if let navController = navigationController {
			System.clearNavigationBar(forBar: navController.navigationBar)
			navController.view.backgroundColor = .clear
		}
		
		//updates attributes
		navigationController?.navigationBar.barTintColor = UIColor.black
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.groupTableViewBackground]
	}
}

//MARK: - Navigation
extension WelcomeController {
	override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		if segue?.identifier == "signIn" {
			let backItem = UIBarButtonItem()
			backItem.title = "Back"
			navigationItem.backBarButtonItem = backItem
			navigationItem.backBarButtonItem?.tintColor = UIColor.black
		}
		
		if segue?.identifier == "signUp" {
			let backItem = UIBarButtonItem()
			backItem.title = "Back"
			navigationItem.backBarButtonItem = backItem
			navigationItem.backBarButtonItem?.tintColor = UIColor.black
		}
	}
}
