//
//  AccountTableViewController.swift
//  AIProject
//
//  Created by Victor Ruiz on 11/15/21.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class AccountTableViewController: UITableViewController {
	@IBOutlet weak var logOutButton: UIButton!
	@IBAction func backButton(_ sender: Any?) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@objc func handleSignOutButtonTapped(sender: UIButton!) {
		let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) {
			(action) in
			do {
				try Auth.auth().signOut()
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let vc = storyboard.instantiateViewController(withIdentifier: "idMyViewControllerName") as! WelcomeNavigationController
				vc.modalPresentationStyle = .fullScreen
				self.present(vc, animated: true, completion: nil)
			}
			catch let err {
				print("Failed to sign out with error", err)
				Service.showAlert(on: self, style: .alert, title: "Sign Out Error", message: err.localizedDescription)
			}
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		Service.showAlert(on: self, style: .actionSheet, title: nil, message: nil, actions: [signOutAction, cancelAction], completion: nil)
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.prefersLargeTitles = false
		logOutButton.addTarget(self, action: #selector(handleSignOutButtonTapped), for: .touchUpInside)
		tableView.separatorStyle = .none
	}
	
	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		view.tintColor = UIColor.white
	}
	
	
	override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		let backItem = UIBarButtonItem()
		backItem.title = "Back"
		navigationItem.backBarButtonItem = backItem
		navigationItem.backBarButtonItem?.tintColor = UIColor.black
	}
}
