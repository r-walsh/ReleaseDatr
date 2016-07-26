//
//  ReleaseItem.swift
//  datr-ios
//
//  Created by Ryan Walsh on 7/7/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import Foundation

class ReleaseItem {

	private let nameKey = "name"
	private let mediaTypeKey = "mediaType"
	private let releaseDateKey = "releaseDate"
	private let releaseDateConfirmedKey = "releaseDateConfirmed"
	private let releaseDateSourcesKey = "releaseDateSources"
	private let _idKey = "_id"

	let name: String
	let mediaType: String
	let releaseDate: NSDate
	let releaseDateString: String
	let releaseDateConfirmed: Bool
	let releaseDateSources: [ String ]
	let _id: String

	var jsonValue: [ String:AnyObject ] {
		return [
				nameKey: name,
				mediaTypeKey: mediaType,
				releaseDateKey: releaseDateString,
				releaseDateConfirmedKey: releaseDateConfirmed,
				releaseDateSourcesKey: releaseDateSources,
				_idKey: _id
		]
	}

	var jsonData: NSData? {
		return try? NSJSONSerialization.dataWithJSONObject( jsonValue, options: .PrettyPrinted )
	}

	init?( itemAsDictionary: [ String:AnyObject ] ) {
		guard let name = itemAsDictionary[ nameKey ] as? String,
		let mediaType = itemAsDictionary[ mediaTypeKey ] as? String,
		let releaseDate = itemAsDictionary[ releaseDateKey ] as? String,
		let releaseDateConfirmed = itemAsDictionary[ releaseDateConfirmedKey ] as? Bool,
		let releaseDateSources = itemAsDictionary[ releaseDateSourcesKey ] as? [ String ],
		let _id = itemAsDictionary[ _idKey ] as? String
		else {
			return nil
		}

		if let date = ReleaseItemController.sharedController.formatStringToNSDate( releaseDate ) {
			self.name = name
			self.mediaType = mediaType
			self.releaseDate = date
			self.releaseDateConfirmed = releaseDateConfirmed
			self.releaseDateSources = releaseDateSources
			self.releaseDateString = ReleaseItemController.sharedController.formatDateToString( date )
			self._id = _id
		} else {
			return nil
		}

	}

	init( name: String, mediaType: MediaTypes, releaseDate: NSDate, releaseDateConfirmed: Bool, releaseDateSources: [ String ], _id: String = "" ) {

		self.name = name
		self.mediaType = mediaType.rawValue
		self.releaseDate = releaseDate
		self.releaseDateConfirmed = releaseDateConfirmed
		self.releaseDateSources = releaseDateSources
		self.releaseDateString = ReleaseItemController.sharedController.formatDateToString( releaseDate )
		self._id = _id
	}

}

enum MediaTypes: String {
	case Book, Movie, TV, Game, Music

	static var mediaTypesArray: [ String ] {
		return [ "Book", "Movie", "TV", "Music", "Game" ]
	}
}
