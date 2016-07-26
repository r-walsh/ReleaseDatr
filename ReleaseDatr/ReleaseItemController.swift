//
//  ReleaseItemController.swift
//  datr-ios
//
//  Created by Ryan Walsh on 7/7/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import Foundation

class ReleaseItemController {
	static let sharedController = ReleaseItemController()

	private let url = NSURL( string: "http://localhost:3000/api/release-items" )
	private static let bookKey = "Book"
	private static let movieKey = "Movie"
	private static let tvKey = "TV"
	private static let musicKey = "Music"
	private static let gameKey = "Game"

	// caching seconds since last request
	var timeOfLastRequest: Dictionary<String, Double> = [
			bookKey: 0.0,
			movieKey: 0.0,
			tvKey: 0.0,
			musicKey: 0.0,
			gameKey: 0.0
	]

	var releaseItemsByType: Dictionary<String, [ ReleaseItem ]> = [
			bookKey: [],
			movieKey: [],
			tvKey: [],
			gameKey: [],
			musicKey: []
	]

	var releaseItems: [ ReleaseItem ] = []

	func createReleaseItem( name: String, mediaType: MediaTypes, releaseDate: NSDate, releaseDateConfirmed: Bool = false, releaseDateSources: [ String ] ) -> ReleaseItem {
		return ReleaseItem( name: name, mediaType: mediaType, releaseDate: releaseDate, releaseDateConfirmed: releaseDateConfirmed, releaseDateSources: releaseDateSources )
	}

	func formatDateToString( date: NSDate ) -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"

		return dateFormatter.stringFromDate( date )

	}

	func formatStringToNSDate( date: String ) -> NSDate? {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

		return dateFormatter.dateFromString( date )
	}

	func formatDateToDisplayString( date: NSDate ) -> String? {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "MMM dd, yyyy"

		return dateFormatter.stringFromDate( date )
	}

	func jsonToDictionary( json: NSData ) {
		do {
			let releaseItemDictionaries = try NSJSONSerialization.JSONObjectWithData( json, options: [] ) as? [ [ String:AnyObject ] ]

			if let releaseItemDictionaries = releaseItemDictionaries {
				self.releaseItems = []
				for item in releaseItemDictionaries {
					let releaseItem = ReleaseItem( itemAsDictionary: item )

					if let unwrappedReleaseItem = releaseItem {
						self.releaseItemsByType[ unwrappedReleaseItem.mediaType ]?.append( unwrappedReleaseItem )
					}
				}
			}
		} catch {
			print( error )
		}
	}

	func buildUrl( type: String? ) -> NSURL? {
		if let mediaType = type {
			return NSURL( string: "http://localhost:3000/api/release-items/\( mediaType )" )
		}
		return NSURL( string: "http://localhost:3000/api/release-items" )
	}

	// MARK: - Network Requests

	func getReleaseItemsOfType( type: MediaTypes, completion: ( ( results:[ ReleaseItem ]? ) -> Void )? = nil ) {
		guard let requestURL = buildUrl( type.rawValue ) else {
			fatalError( "URL optional is nil" )
		}

		NetworkController.performRequestForURL( requestURL, httpMethod: .GET ) {
			( data, error ) in

			if error != nil {
				print( error )
			}

			if let responseData = data {
				let responseDataString = NSString( data: responseData, encoding: NSUTF8StringEncoding ) ?? ""

				if responseDataString.containsString( "error" ) {
					print( responseDataString )
				} else {
					self.jsonToDictionary( responseData )
					if let cb = completion {
						cb( results: self.releaseItemsByType[ type.rawValue ] )
					}
				}
			}
		}
	}

	func postReleaseItem( releaseItem: ReleaseItem ) {

		guard let requestURL = buildUrl( nil ) else {
			fatalError( "URL optional is nil" )
		}

		NetworkController.performRequestForURL( requestURL, httpMethod: .POST, body: releaseItem.jsonData ) {
			( data, error ) in

			if error != nil {
				print( error )
			}

			if let dataResponse = data {
				let responseDataString = NSString( data: dataResponse, encoding: NSUTF8StringEncoding ) ?? ""

				if error != nil {
					print( " Error: \( error )" )
				} else if responseDataString.containsString( "error" ) {
					print( "Error: \( responseDataString )" )
				} else {
					self.jsonToDictionary( dataResponse )
				}
			}

		}
	}
}