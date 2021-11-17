//
//  FetchHelper.swift
//  AIProject
//
//  Created by Victor Ruiz on 11/10/21.
//

import Foundation

class FetchHelper {
	//setting constants
	enum HTTPError: Error {
		case non200StatusCode
		case noData
		case conflict
	}
	
	//Will submit data task with request
	/// - Paramaters:
	/// - request: URL Request to be made
	func fetchData(with request: URLRequest, requestID: String? = nil, completion: @escaping (String?, Data?, Error?) -> Void) {
		
		//data task
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			//error handling
			if let error = error {
				print(error)
				completion(requestID, nil, error)
				return
			} else if let response = response as? HTTPURLResponse, !(200...201).contains(response.statusCode) {
				print("non 200 http response: \(response.statusCode)")
				print(String(data: data!, encoding: .utf8))
				let myError = response.statusCode == 409 ?  HTTPError.conflict :  HTTPError.non200StatusCode  // Must check if user already exists (response 409)
				completion(requestID, nil, myError)
				return
			}
			
			guard let data = data else {
				completion(requestID, nil, HTTPError.noData)
				return
			}
			completion(requestID, data, nil)
			}.resume()
	}
}
