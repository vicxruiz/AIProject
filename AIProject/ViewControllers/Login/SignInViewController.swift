//
//  SignInViewController.swift
//  AIProject
//
//  Created by Victor Ruiz on 11/10/21.
//

import Foundation
import UIKit
import FirebaseAuth
import JGProgressHUD
import FirebaseStorage
import FirebaseDatabase

class SignInViewController: UIViewController {
	//Properties
	@IBOutlet weak var forgotPassword: UIButton!
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var dismissButton: UIButton!
	
	let hud: JGProgressHUD = {
		let hud = JGProgressHUD(style: .dark)
		hud.interactionType = .blockAllTouches
		return hud
	}()
	
	//Actions
	
	@IBAction func dismissButtonPressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func forgotPasswordButtonPressed(_ sender: Any) {
		performSegue(withIdentifier: "forgot", sender: self)
	}
	
	override func viewDidLoad() {
		updateNavBar()
		loginButton.layer.masksToBounds = true
		loginButton.layer.cornerRadius = 15
		self.hideKeyboardWhenTappedAround()
	}
	
	func updateNavBar() {
		if let navController = navigationController {
			System.clearNavigationBar(forBar: navController.navigationBar)
			navController.view.backgroundColor = .clear
		}
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	//Handles logic to when sign in button is tapped
	@IBAction func signInButtonTapped(_ sender: Any) {
		//error handling
		guard let email = emailField.text else {return}
		guard let password = passwordField.text else {return}
		hud.textLabel.text = "Signing In..."
		hud.show(in: view, animated: true)
		//firebase method to log user in and then performs log in segue
		Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
			if let error = error {
				self.hud.dismiss(animated: true)
				print("Failed to sign in with error", error)
				Service.showAlert(on: self, style: .alert, title: "Sign In Error", message: error.localizedDescription)
				return
			}
			self.hud.dismiss(animated: true)
			self.performSegue(withIdentifier: "loginA", sender: self)
		}
}
	
	
	//handles keyboard functionality
	func textFieldShouldReturn(emailField: UITextField) -> Bool {
		emailField.resignFirstResponder()
		return true
	}
	
	override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
		let backItem = UIBarButtonItem()
		backItem.title = "Back"
		navigationItem.backBarButtonItem = backItem
		navigationItem.backBarButtonItem?.tintColor = UIColor.black
	}
}
