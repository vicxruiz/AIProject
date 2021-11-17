//
//  ViewController.swift
//  AIProject
//
//  Created by Victor Ruiz on 11/15/21.
//

import AlanSDK
import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import Mapbox
import CoreLocation
import MapKit
import SideMenu


class ViewController: UIViewController {
	
	var mapView: MGLMapView!
	let businessController = BusinessController()
	var didLoadBusinesses = false
	var businessId: String?
	var businesses: [Business]? { didSet { mapBusinesses() } }
	var openBusinesses: [Business] = []
	var button: AlanButton?
	var text: AlanText!
	var lat: CLLocationDegrees?
	var lng: CLLocationDegrees?
	
	enum BusinessDisplay {
		case open
		case all
	}
	
	var businessDisplay: BusinessDisplay = .all
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		handleCommands()
	}
}

//MARK: - Alan commands
extension ViewController {
	func handleCommands() {
		guard let button = self.button else { return }
		/// Handle commands from Alan Studio
		button.onCommand = { command in
			print("Handling command")
			guard let commandName = command?["command"] as? String else {
				return
			}
			switch commandName {
			case Command.showAllNearby:
				guard let lat = self.lat, let lng = self.lng else { return }
				self.fetchBusinesses(lat: lat, lng: lng, open: false)
			default:
				break
			}
		}
	}
}

//MARK: - Setup Views
extension ViewController {
	private func setupViews() {
		setupMap()
		setupAlan()
		setupSideMenu()
	}
	
	private func setupAlan() {
		/// Define the project key
		let config = AlanConfig(key: "04e977ebbf964ee841dfc026ed4c2fe72e956eca572e1d8b807a3e2338fdd0dc/stage")
		
		///  Init the Alan button
		self.button = AlanButton(config: config)
		
		self.text = AlanText(frame: CGRect.zero)
		
		/// Add the button to the view
		self.view.addSubview(self.button!)
		self.button!.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(self.text)
		self.text.translatesAutoresizingMaskIntoConstraints = false
		
		/// Align the button and text panel on the view
		let views = ["button" : self.button!, "text" : self.text!]
		let verticalButton = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=0@299)-[button(64)]-40-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views)
		let verticalText = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=0@299)-[text(64)]-40-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views)
		let horizontalButton = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=0@299)-[button(64)]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views)
		let horizontalText = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[text]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views)
		self.view.addConstraints(verticalButton + verticalText + horizontalButton + horizontalText)
	}
	
	private func setupMap() {
		mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.outdoorsStyleURL)
		mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.addSubview(mapView)
		mapView.delegate = self
		mapView.showsUserLocation = true
		mapView.userTrackingMode = .follow
	}
	
	private func setupSideMenu() {
		let hamburgerButton = UIButton(frame: CGRect(x: view.frame.width / 17, y: view.frame.height / 20, width: 40, height: 40))
		let hamburgerImage = UIImage(named: "hamburgerMenu")
		let tintedHamburger = hamburgerImage?.withRenderingMode(.alwaysTemplate)
		hamburgerButton.setImage(tintedHamburger, for: .normal)
		hamburgerButton.tintColor = UIColor.lightGray
		
		hamburgerButton.addTarget(self, action: #selector(sideMenuSegue), for: .touchUpInside)
		self.view.addSubview(hamburgerButton)
	}
}

//MARK: - Navigation
extension ViewController {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "ShowSideMenu" {
			guard let destinationNavC = segue.destination as? SideMenuNavigationController,
				let destinationVC = destinationNavC.topViewController as? SideMenuViewController else { return }
			destinationNavC.statusBarEndAlpha = 0
		}
		if segue.identifier == "AnnotationSegue" {
			guard let destinationNavC = segue.destination as? BusinessDetailNavC, let destinationVC = destinationNavC.topViewController as? BusinessDetailViewController else { return }
			destinationVC.businessId = self.businessId
			destinationVC.businessController = self.businessController
		}
	}

	
	@objc func sideMenuSegue(sender: UIButton!) {
		  self.performSegue(withIdentifier: "ShowSideMenu", sender: self)
	  }
}

//MARK: - Helper Functions
extension ViewController {
	func fetchBusinesses(lat: Double, lng: Double, open: Bool?) {
		businessController.searchBusinesses(latitude: lat, longitude: lng, open: open) { (businessResult, error) in
			if error != nil {
				DispatchQueue.main.async {
					if open != nil {
						Service.showAlert(on: self, style: .alert, title: "Error fetching", message: "Please check your connection status and try again.")
						return
					}
					Service.showAlert(on: self, style: .alert, title: "Error fetching", message: "Please check your connection status and try again.")
					return
				}
			}
			if let businesses = businessResult {
				self.businesses = businesses
			}
		}
	}
	
	func mapBusinesses() {
		guard let businesses = businesses else { return }
		
		if let annotations = mapView.annotations {
			mapView.removeAnnotations(annotations)
		}

		DispatchQueue.main.async {
			for business in businesses {
				let marker = MGLPointAnnotation()
				let coordinate = CLLocationCoordinate2DMake(business.coordinates.latitude, business.coordinates.longitude)
				marker.title = business.name
				let distance = Service.convertMeterToMiles(distance: business.distance)
				let roundedDistance = String(format: "%.2f", distance)
				marker.subtitle = "\(roundedDistance) Miles"
				marker.coordinate = coordinate
				self.mapView.addAnnotation(marker)
			}
		}
		
	}
}

//MARK: - Mapbox
extension ViewController: MGLMapViewDelegate {
	func  mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
		guard let lat = userLocation?.coordinate.latitude, let lng = userLocation?.coordinate.longitude else {
			Service.showAlert(on: self, style: .alert, title: "Error fetching user location.", message: "Please check your connection and try agian.")
			return
		}
		self.lat = lat
		self.lng = lng
	}
	
	// Use the default marker. See also: our view annotation or custom marker examples.
	func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
		return nil
	}
	 
	// Allow callout view to appear when an annotation is tapped.
	func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
		return true
	}
	
	func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
		// Hide the callout view.
		mapView.deselectAnnotation(annotation, animated: false)
		guard let businesses = businesses else {return}
		for business in businesses  {
			if annotation.coordinate.latitude == business.coordinates.latitude && annotation.coordinate.longitude == business.coordinates.longitude {
				self.businessId = business.id
				break
			}
		}
		// Show an alert containing the annotation's details
		performSegue(withIdentifier: "AnnotationSegue", sender: self)
	}
	
	func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
		return UIButton(type: .detailDisclosure)
	}
}

