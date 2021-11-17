//
//  AppDelegate.swift
//  AIProject
//
//  Created by Victor Ruiz on 11/10/21.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		FirebaseApp.configure()
		let userDefaults = UserDefaults.standard
		
		if userDefaults.bool(forKey: "hasRunBefore") == false {
			print("The app is launching for the first time. Setting UserDefaults...")
			
			do {
				try Auth.auth().signOut()
			} catch {
				//error handling
				print("Unable to sign out")
			}
			
			userDefaults.set(true, forKey: "hasRunBefore")
			// Update the flag indicator
			userDefaults.synchronize() // This forces the app to update userDefaults
			// Run code here for the first launch
		}
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
}

