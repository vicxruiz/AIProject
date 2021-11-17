//
//  BusinessController.swift
//  AIProject
//
//  Created by Victor Ruiz on 11/10/21.
//

import Foundation
import UIKit

class BusinessController {
	
	//MARK: - Props
	
	/// Client Key for yelp
	/// - Should store in database
	let clientKey = "Hn_QiWGiSTxVtLo1qNOnHQa7mGf02iyoVounoIyZyZ7A-ayuHFtpnJdkKptAEn1gzJa94hY0EkryBsIZZ7lJtR1MKwfvGigUh4qSzy469nqKkR9a0Nbf4mV7A2rgXXYx"
	
	let baseURL = URL(string: "https://api.yelp.com/v3")!
	let dataGetter = FetchHelper()
	var businessId = ""
	
	enum Endpoint: String {
		case search = "/search"
	}
	
	enum HTTPMethod: String {
		case get = "GET"
		case put = "PUT"
		case post = "POST"
		case delete = "DELETE"
	}
	
	//MARK: - Helper functions
	
	//Will search businesses for specific location
	/// - Paramaters:
	/// - latititude: Used for location
	/// - longitude: Used for location
	/// - open: Business open or closed status
	func searchBusinesses(latitude: Double, longitude: Double, open: Bool?, completion: @escaping ([Business]?, Error?) -> Void) {
		
		let searchURL = baseURL.appendingPathComponent("businesses/search")
		var components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
		guard components != nil else { print("No components"); return }
		
		let veterinaryQueryItem = URLQueryItem(name: "term", value: "restaurant")
		let latitudeQueryItem = URLQueryItem(name: "latitude", value: "\(latitude)")
		let longitudeQueryItem = URLQueryItem(name: "longitude", value: "\(longitude)")
		if open != nil {
			let openQueryItem = URLQueryItem(name: "open_now", value: "true")
			components?.queryItems = [veterinaryQueryItem, latitudeQueryItem, longitudeQueryItem, openQueryItem]
		} else {
			components?.queryItems = [veterinaryQueryItem, latitudeQueryItem, longitudeQueryItem]
		}
		
		guard let url = components?.url else { print("no url"); return}

		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.get.rawValue
		request.addValue("Bearer \(clientKey)", forHTTPHeaderField: "Authorization")
		
		dataGetter.fetchData(with: request) { (_, data, error) in
			//error handling
			if let error = error {
				completion(nil, error)
			}
			guard let data = data else { return }
			
			//decoding
			let decoder = JSONDecoder()
			do {
				let data = try decoder.decode(Response.self, from: data)
				let businesses = data.businesses
				completion(businesses, nil)
			} catch {
				print("error decoding data: \(error)")
				completion(nil, error)
			}
		}
	}
	
	//Will search business by id
	/// - Paramaters:
	/// - id: business id
	func searchBusiness(by id: String, completion: @escaping (BusinessDetail?, Error?) -> Void) {
		let searchURL = baseURL.appendingPathComponent("businesses/\(id)")
		let components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
		guard components != nil else { print("No components"); return }
		
		guard let url = components?.url else { print("no url"); return}
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.get.rawValue
		request.addValue("Bearer \(clientKey)", forHTTPHeaderField: "Authorization")

		dataGetter.fetchData(with: request) { (_, data, error) in
			//error handling
			if let error = error {
				completion(nil, error)
			}
			guard let data = data else { print("no data"); return }
			
			//decoding
			let decoder = JSONDecoder()
			do {
				let data = try decoder.decode(BusinessDetail.self, from: data)
				completion(data, nil)
			} catch {
				print("error decoding data: \(error)")
				completion(nil, error)
			}
		}
	}
}
