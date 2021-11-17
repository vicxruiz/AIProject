//
//  Service.swift
//  AIProject
//
//  Created by Victor Ruiz on 11/10/21.
//

import Foundation
import UIKit
import JGProgressHUD

class Service {
	
	//MARK: - Static props
	
	static let meterToMiles = 1609.344
	static let buttonTitleFontSize: CGFloat = 18
	static let buttonTitleColor = UIColor.white
	static let buttonCornerRadius: CGFloat = 7
	
	//MARK: - Helper functions
	static func showAlert(on: UIViewController, style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [ UIAlertAction(title: "OK", style: .default, handler: nil)], completion: (() -> Swift.Void)? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: style)
		for action in actions {
			alert.addAction(action)
		}
		on.present(alert, animated: true, completion: completion)
	}

	static func convertMeterToMiles(distance: Double) -> Double {
		return distance / 1609.344
	}
	
	static func dissmissHud(_ hud: JGProgressHUD, text: String, detailText: String, delay: TimeInterval) {
		hud.textLabel.text = text
		hud.detailTextLabel.text = detailText
		hud.dismiss(afterDelay: delay, animated: true)
	}
}

