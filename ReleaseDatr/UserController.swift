//
//  UserController.swift
//  ReleaseDatr
//
//  Created by Ryan Walsh on 7/25/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import Foundation
import Lock

class UserController {

	private let url = NSURL( string: "http://localhost:3000/api/users" )

	static let sharedController = UserController()

	var user: User?

	func jsonToDictionary( json: NSData ) {
		do {
			let userDictionary = try NSJSONSerialization.JSONObjectWithData( json, options: [] ) as? [ String:AnyObject ]

			if let userDictionary = userDictionary, user = User( userDictionary: userDictionary ) {
				self.user = user
			}
		} catch {
			print( error )
		}
	}

	func presentLoginView( fromController: UIViewController ) {
		let controller = A0Lock.sharedLock().newLockViewController()
		controller.closable = true
		controller.onAuthenticationBlock = {
			profile, token in
			if let userProfile = profile, email = userProfile.email {
				UserController.sharedController.postUser( User( name: userProfile.name, email: email ) )
			}

			controller.dismissViewControllerAnimated( true, completion: nil )
		}
		A0Lock.sharedLock().presentLockController( controller, fromController: fromController )

	}

	// MARK: - Network Requests
	func postUser( user: User ) {
		guard let url = url else {
			fatalError( "URL optional is nil" )
		}

		NetworkController.performRequestForURL( url, httpMethod: .POST, body: user.userJson ) {
			(data, error) in
			if error != nil {
				print( error )
			}

			if let responseData = data {
				let responseDataString = NSString( data: responseData, encoding: NSUTF8StringEncoding ) ?? ""

				if responseDataString.containsString( "error" ) {
					print( responseDataString )
				} else {
					self.jsonToDictionary( responseData )
				}
			}
		}
	}
}
