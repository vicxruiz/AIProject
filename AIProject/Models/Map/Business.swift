//
//  Business.swift
//  AIProject
//
//  Created by Victor Ruiz on 11/15/21.
//

import Foundation

struct Response: Codable {
	var businesses: [Business]
}

struct Business: Codable {
	var id: String
	var name: String
	var image_url: String
	var is_closed: Bool
	var review_count: Int
	var rating: Double
	var phone: String
	var display_phone: String
	var distance: Double
	var coordinates: Coordinate
}

struct Coordinate: Codable {
	var latitude: Double
	var longitude: Double
}

struct BusinessDetail: Codable {
	var name: String
	var image_url: String
	var is_closed: Bool
	var phone: String
	var display_phone: String
	var review_count: Int
	var rating: Double
	var hours: [Hours]
	var location: Location
	var coordinates: Coordinate
	var photos: [String]
}

struct Location: Codable {
	var display_address: [String]
}

struct Hours: Codable {
	var open: [Open]
	var is_open_now: Bool
}

struct Open: Codable {
	var start: String
	var end: String
	var day: Int
}

