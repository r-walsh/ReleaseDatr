//
//  HomeViewController.swift
//  ReleaseDatr
//
//  Created by Ryan Walsh on 7/22/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

	@IBOutlet weak var booksButton: UIButton!
	@IBOutlet weak var moviesButton: UIButton!
	@IBOutlet weak var tvButton: UIButton!
	@IBOutlet weak var gamesButton: UIButton!
	@IBOutlet weak var musicButton: UIButton!
	@IBOutlet weak var loadingReleaseItemsIndicator: UIActivityIndicatorView!

	let releaseItemCtrl = ReleaseItemController.sharedController

	private enum SelectedButtonTag: Int {
		case Book, Movie, TV, Game, Music

		var description: String {
			switch self {
				case .Book: return "Book"
				case .Movie: return "Movie"
				case .TV: return "TV"
				case .Game: return "Game"
				case .Music: return "Music"
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		loadingReleaseItemsIndicator.hidden = true

		let borderColor = UIColor( red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0 )

		booksButton.addBorder( .Top, color: borderColor, width: 1 )
		moviesButton.addBorder( .Top, color: borderColor, width: 1 )
		tvButton.addBorder( .Top, color: borderColor, width: 1 )
		gamesButton.addBorder( .Top, color: borderColor, width: 1 )
		musicButton.addBorder( .Top, color: borderColor, width: 1 )
		musicButton.addBorder( .Bottom, color: borderColor, width: 1 )
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func determinePressedButton( tag: Int ) -> String? {
		switch tag {
			case SelectedButtonTag.Book.rawValue: return "Book"
			case SelectedButtonTag.Movie.rawValue: return "Movie"
			case SelectedButtonTag.TV.rawValue: return "TV"
			case SelectedButtonTag.Game.rawValue: return "Game"
			case SelectedButtonTag.Music.rawValue: return "Music"
			default: return nil
		}
	}

	func hideIndicatorAndPerformSegue( sender: AnyObject ) {
		loadingReleaseItemsIndicator.stopAnimating()
		loadingReleaseItemsIndicator.hidden = true
		performSegueWithIdentifier( "showReleaseItems", sender: sender )
	}

	// Mark: - Actions

	@IBAction func releaseItemButtonPressed( sender: UIButton ) {
		loadingReleaseItemsIndicator.startAnimating()
		loadingReleaseItemsIndicator.hidden = false

		if let mediaType = determinePressedButton( sender.tag ), let timeOfLastRequest = releaseItemCtrl.timeOfLastRequest[ mediaType ] {

			let intervalSince1970 = NSDate().timeIntervalSince1970

			// determine if a request has been made, and whether or not it has been more than 60 seconds
			if timeOfLastRequest == 0 || intervalSince1970 - timeOfLastRequest > 60 {
				releaseItemCtrl.timeOfLastRequest[ mediaType ] = intervalSince1970
				releaseItemCtrl.getReleaseItemsOfType( MediaTypes( rawValue: mediaType )! ) {
					( result ) -> Void in
					dispatch_async( dispatch_get_main_queue() ) {
						self.hideIndicatorAndPerformSegue( sender )
					}
				}
			} else {
				hideIndicatorAndPerformSegue( sender )
			}
		}
	}


	// MARK: - Navigation

	override func prepareForSegue( segue: UIStoryboardSegue, sender: AnyObject? ) {
		if segue.identifier == "showReleaseItems" {
			if let destination = segue.destinationViewController as? ReleaseItemTableViewController,
			mediaType = SelectedButtonTag( rawValue: sender!.tag ) {
				destination.mediaType = mediaType.description
			}
		}
	}

}
