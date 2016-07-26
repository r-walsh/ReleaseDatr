//
//  User.swift
//  ReleaseDatr
//
//  Created by Ryan Walsh on 7/25/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import Foundation

struct User {
	private let nameKey = "name"
	private let emailKey = "email"
	private let _idKey = "_id"
	private let watchedItemsKey = "watchedItems"

	let name: String
	let email: String
	let _id: String
	let watchedItems: [ ReleaseItem ]

	init( name: String, email: String, _id: String = "", watchedItems: [ ReleaseItem ] = [] ) {
		self.name = name
		self.email = email
		self._id = ""
		self.watchedItems = watchedItems
	}

	init?( userDictionary: [ String:AnyObject ] ) {
		guard let name = userDictionary[ nameKey ] as? String,
		let email = userDictionary[ emailKey ] as? String,
		let _id = userDictionary[ _idKey ] as? String,
		let watchedItems = userDictionary[ watchedItemsKey ] as? [ ReleaseItem ]
		else {
			return nil
		}

		self.name = name
		self.email = email
		self._id = _id
		self.watchedItems = []
	}

	var userDictionary: [ String:AnyObject ] {
		return [
				nameKey: name,
				emailKey: email,
				_idKey: _id,
				watchedItemsKey: watchedItems
		]
	}

	var userJson: NSData? {
		return try? NSJSONSerialization.dataWithJSONObject( userDictionary, options: .PrettyPrinted )
	}
}
