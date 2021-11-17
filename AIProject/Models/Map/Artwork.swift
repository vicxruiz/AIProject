//
//  Artwork.swift
//  AIProject
//
//  Created by Victor Ruiz on 11/15/21.
//

import Foundation
import MapKit
import UIKit
import Contacts

//Model for design label on St Francis
class Artwork: NSObject, MKAnnotation {
	let title: String?
	let locationName: String
	let discipline: String
	let coordinate: CLLocationCoordinate2D
	
	init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
		self.title = title
		self.locationName = locationName
		self.discipline = discipline
		self.coordinate = coordinate
		
		super.init()
	}
	
	// Annotation right callout accessory opens this mapItem in Maps app
	func mapItem() -> MKMapItem {
		let addressDict = [CNPostalAddressStreetKey: subtitle!]
		let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
		let mapItem = MKMapItem(placemark: placemark)
		mapItem.name = title
		return mapItem
	}
	
	var subtitle: String? {
		return locationName
	}
}
