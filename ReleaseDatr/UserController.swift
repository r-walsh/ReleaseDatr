//
//  UserController.swift
//  ReleaseDatr
//
//  Created by Ryan Walsh on 7/25/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import Foundation
import Lock
import SimpleKeychain

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

	func handleAuth( fromController: UIViewController ) {
		let keychain = A0SimpleKeychain( service: "Auth0" )

		guard let idToken = keychain.stringForKey( "id_token" ) else {
			presentLoginView( fromController, keychain: keychain )
			return
		}

		let client = A0Lock.sharedLock().apiClient()

		client.fetchUserProfileWithIdToken(
				idToken,
				success: {
					profile in
					UserController.sharedController.postUser( User( name: profile.name, email: profile.email! ) )

					keychain.setData( NSKeyedArchiver.archivedDataWithRootObject( profile ), forKey: "profile" )
				},
				failure: {
					error in
					keychain.clearAll()

					self.handleExpiredToken( fromController, keychain: keychain, apiClient: client )
				} )
	}

	func handleExpiredToken( fromController: UIViewController, keychain: A0SimpleKeychain, apiClient: A0APIClient ) {
		guard let refreshToken = keychain.stringForKey( "refresh_token" ) else {
			keychain.clearAll()
			presentLoginView( fromController, keychain: keychain )
			return
		}

		apiClient.fetchNewIdTokenWithRefreshToken(
				refreshToken,
				parameters: nil,
				success: {
					newToken in
					keychain.setString( newToken.idToken, forKey: "id_token" )
					self.handleAuth( fromController )
				},
				failure: {
					error in
					keychain.clearAll()
					self.presentLoginView( fromController, keychain: keychain )
				} )
	}

	func presentLoginView( fromController: UIViewController, keychain: A0SimpleKeychain ) {

		let controller = A0Lock.sharedLock().newLockViewController()
		controller.closable = true
		controller.onAuthenticationBlock = {
			profile, token in

			keychain.setString( token!.idToken, forKey: "id_token" )
			keychain.setString( token!.refreshToken!, forKey: "refresh_token" )

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
