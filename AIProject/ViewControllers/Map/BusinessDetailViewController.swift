//
//  BusinessDetailViewController.swift
//  AIProject
//
//  Created by Victor Ruiz on 11/15/21.
//

import Foundation
import UIKit
import JGProgressHUD
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Mapbox
import CoreLocation
import MapKit

class BusinessDetailNavC: UINavigationController {
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

class BusinessDetailViewController: UIViewController {
	
	var businessController: BusinessController?
	var businessId: String?
	var business: BusinessDetail?
	
	@IBOutlet weak var businessImageView: UIImageView!
	@IBOutlet weak var businessImageView2: UIImageView!
	@IBOutlet weak var businessImageView3: UIImageView!
	@IBOutlet weak var hoursTextView: UITextView!
	@IBOutlet weak var addressTextView: UITextView!
	@IBOutlet weak var openLabel: UILabel!
	@IBOutlet weak var ratingsLabel: UILabel!
	@IBOutlet weak var primaryContactButton: UIButton!
	@IBOutlet weak var getDirectionsButton: UIButton!
	@IBOutlet weak var makePrimaryContactButton: UIButton!
	
	//displays progress sign
	let hud: JGProgressHUD = {
		let hud = JGProgressHUD(style: .light)
		hud.interactionType = .blockAllTouches
		return hud
	}()
	
	@IBAction func dismissButtonPressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		hud.textLabel.text = "Loading information..."
		hud.show(in: view, animated: true)
		getDirectionsButton.layer.masksToBounds = true
		getDirectionsButton.layer.cornerRadius = Service.buttonCornerRadius
		fetchBusinessDetails()
	}
}

//MARK: - Setup Views

extension BusinessDetailViewController {
	func updateViews() {
		guard let business = business else {
			self.hud.dismiss(animated: true)
			DispatchQueue.main.async {
				Service.showAlert(on: self, style: .alert, title: "Error fetching details.", message: "Please check connection")
			}
			return
		}
		
		self.title = business.name
		if UserDefaults.standard.value(forKey: "PrimaryContact") as? String == business.phone {
			primaryContactButton.isHidden = true
		}
		
		var images: [UIImage] = []
		
		for index in 0..<business.photos.count {
			let image = self.convertURLToImage(imageURL: business.photos[index])
			images.append(image)
		}
		
		for index in 0..<images.count {
			if index == 0 {
				self.businessImageView.image = images[0]
			}
			if index == 1 {
				self.businessImageView2.image = images[1]
			}
			if index == 2 {
				self.businessImageView3.image = images[2]
			}
		}
		
		if business.hours[0].is_open_now {
			self.openLabel.text = "OPEN"
			self.openLabel.textColor = UIColor.green
		} else {
			self.openLabel.text = "CLOSED"
			self.openLabel.textColor = UIColor.red
		}
	
		var displayAddress = ""
		for address in business.location.display_address {
			displayAddress += " \(address)"
		}
		
		var hoursDescription = ""
		var mondayHours = "Closed"
		var tuesdayHours = "Closed"
		var wednesdayHours = "Closed"
		var thursdayHours = "Closed"
		var fridayHours = "Closed"
		var saturdayHours = "Closed"
		var sundayHours = "Closed"
		
		
		for openHours in business.hours {
			for hour in openHours.open {
				if hour.day == 0 {
					let startString = hour.start
					let endString = hour.end
					if let _ = Int(startString), let _ = Int(endString) {
						let mondayStart = convertToStandardTime(time: startString)
						let mondayClose = convertToStandardTime(time: endString)
						mondayHours = "\(mondayStart) - \(mondayClose)"
					} else {
						mondayHours = "Closed"
					}
				} else if hour.day == 1 {
					let startString = hour.start
					let endString = hour.end
					if let _ = Int(startString), let _ = Int(endString) {
						let tueStart = convertToStandardTime(time: startString)
						let tueClose = convertToStandardTime(time: endString)
						tuesdayHours = "\(tueStart) - \(tueClose)"
					} else {
						tuesdayHours = "Closed"
					}
				} else if hour.day == 2 {
					let startString = hour.start
					let endString = hour.end
					if let _ = Int(startString), let _ = Int(endString) {
						let wedStart = convertToStandardTime(time: startString)
						let wedClose = convertToStandardTime(time: endString)
						wednesdayHours = "\(wedStart) - \(wedClose)"
					} else {
						wednesdayHours = "Closed"
					}
				} else if hour.day == 3 {
					let startString = hour.start
					let endString = hour.end
					if let _ = Int(startString), let _ = Int(endString) {
						let thurStart = convertToStandardTime(time: startString)
						let thurClose = convertToStandardTime(time: endString)
						thursdayHours = "\(thurStart) - \(thurClose)"
					} else {
						thursdayHours = "Closed"
					}
				} else if hour.day == 4 {
					let startString = hour.start
					let endString = hour.end
					if let _ = Int(startString), let _ = Int(endString) {
						let friStart = convertToStandardTime(time: startString)
						let friClose = convertToStandardTime(time: endString)
						fridayHours = "\(friStart) - \(friClose)"
					} else {
						fridayHours = "Closed"
					}
				} else if hour.day == 5 {
					let startString = hour.start
					let endString = hour.end
					if let _ = Int(startString), let _ = Int(endString) {
						let satStart = convertToStandardTime(time: startString)
						let satClose = convertToStandardTime(time: endString)
						saturdayHours = "\(satStart) - \(satClose)"
					} else {
						saturdayHours = "Closed"
					}
				} else if hour.day == 6 {
					let startString = hour.start
					let endString = hour.end
					if let _ = Int(startString), let _ = Int(endString) {
						let sunStart = convertToStandardTime(time: startString)
						let sunClose = convertToStandardTime(time: endString)
						sundayHours = "\(sunStart) - \(sunClose)"
					} else {
						sundayHours = "Closed"
					}
				}
			}
		}
		
		hoursDescription = "Monday: \(mondayHours) \nTuesday: \(tuesdayHours) \nWednesday: \(wednesdayHours) \nThursday: \(thursdayHours) \nFriday: \(fridayHours) \nSaturday: \(saturdayHours) \nSunday: \(sundayHours)"
		self.hoursTextView.text = hoursDescription
		self.addressTextView.text = displayAddress
		self.ratingsLabel.text = "\(business.rating) (\(business.review_count)) on Yelp"
		
	}
}

//MARK: - Fetching

extension BusinessDetailViewController {
	func fetchBusinessDetails() {
		guard let businessId = businessId, let businessController = businessController else { print("no data passed"); return}
		
		businessController.searchBusiness(by: businessId) { (business, error) in
			if let error = error {
				DispatchQueue.main.async {
					Service.showAlert(on: self, style: .alert, title: "Error fetching details.", message: "Please check connection")
					print(error)
					self.hud.dismiss(animated: true)
					return
				}
			}
			
			if let business = business {
				self.business = business
				print(business.name)
				DispatchQueue.main.async {
					self.updateViews()
					self.hud.dismiss(animated: true)
				}
			}
		}
	}
}

//MARK: - IBActions

extension BusinessDetailViewController {
	@IBAction func callButtonPressed(_ sender: Any) {
		guard let phoneString = self.business?.phone else {
			Service.showAlert(on: self, style: .alert, title: "No Phone Number Found", message: "Please check your internet connection and try again.")
			return
		}
		var phone = phoneString
		phone.removeFirst()
		phone.removeFirst()
		let string = "tel://\(phone)"
		guard let number = URL(string: string) else {
			Service.showAlert(on: self, style: .alert, title: "Error getting phone details.", message: "Please check your internet connection and try again.")
			return
		}
		UIApplication.shared.open(number)
	}
	
	@IBAction func getDirectionsButtonPressed(_ sender: Any) {
		if let business = business {
			let location = Artwork(title: business.name, locationName: business.name, discipline: "Restaurant", coordinate: CLLocationCoordinate2D(latitude: business.coordinates.latitude, longitude: business.coordinates.longitude))
			let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
			location.mapItem().openInMaps(launchOptions: launchOptions)
		} else {
			DispatchQueue.main.async {
				Service.showAlert(on: self, style: .alert, title: "Error getting directions", message: "Please check your internet connection and try again.")
			}
		}
	}
}

//MARK: - Helper functions

extension BusinessDetailViewController {
	func convertURLToImage(imageURL: String) -> UIImage {
		var image = UIImage()
		if let url = URL(string: imageURL) {
			do {
				let data = try Data(contentsOf: url)
				image = UIImage(data: data) ?? UIImage(named: "no-image")!
			} catch {
				print(error)
			}
		}
		
		return image
	}
	
	func convertToStandardTime(time: String) -> String {
		var presentableTime = time
		presentableTime.insert(":", at: time.index(time.startIndex, offsetBy: 2))
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		let date = dateFormatter.date(from: presentableTime)
		
		dateFormatter.dateFormat = "h:mm: a"
		
		if let date = date {
			let date24 = dateFormatter.string(from: date)
			return date24
		}
		
		return presentableTime
	}
}
