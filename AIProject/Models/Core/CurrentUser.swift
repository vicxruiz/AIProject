//
//  CurrentUser.swift
//  AIProject
//
//  Created by Victor Ruiz on 11/15/21.
//

import Foundation
import UIKit

//Model for user signed in
struct CurrentUser {
	let uid: String
	var name: String
	var phoneNumber: String
	var email: String
	
	init(uid: String, dictionary: [String: Any]) {
		self.uid = uid
		self.name = dictionary["name"] as? String ?? ""
		self.phoneNumber = dictionary["phone number"] as? String ?? ""
		self.email = dictionary["email"] as? String ?? ""
	}
}
