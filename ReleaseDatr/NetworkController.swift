//
//  NetworkController.swift
//  datr-ios
//
//  Created by Ryan Walsh on 7/7/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import Foundation

class NetworkController {

	enum HTTPMethod: String {
		case GET = "GET"
		case PUT = "PUT"
		case POST = "POST"
		case DELETE = "DELETE"
	}

	static func performRequestForURL( url: NSURL, httpMethod: HTTPMethod, urlParameters: [ String:String ]? = nil, body: NSData? = nil, completion: ( ( data:NSData?, error:NSError? ) -> Void )? ) {
		let requestUrl = urlFromURLParameters( url, urlParameters: urlParameters )

		let request = NSMutableURLRequest( URL: requestUrl )
		request.HTTPMethod = httpMethod.rawValue
		request.addValue( "application/json", forHTTPHeaderField: "Content-Type" )
		request.HTTPBody = body

		let session = NSURLSession.sharedSession()

		let dataTask = session.dataTaskWithRequest( request ) {
			( data, response, error ) in
			if let completion = completion {
				completion( data: data, error: error )
			}
		}

		dataTask.resume()
	}

	static func urlFromURLParameters( url: NSURL, urlParameters: [ String:String ]? ) -> NSURL {
		let components = NSURLComponents( URL: url, resolvingAgainstBaseURL: true )

		components?.queryItems = urlParameters?.flatMap( { NSURLQueryItem( name: $0.0, value: $0.1 ) } )

		if let url = components?.URL {
			return url
		}
		fatalError( "URL optional is nil" )
	}

}
 