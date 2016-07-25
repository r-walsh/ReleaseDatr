//
//  ReleaseItemTableViewController.swift
//  ReleaseDatr
//
//  Created by Ryan Walsh on 7/24/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit

class ReleaseItemTableViewController: UITableViewController {

	@IBOutlet weak var navItem: UINavigationItem!

	let releaseItemCtrl = ReleaseItemController.sharedController

	var navTitle: String = "Release Items"
	var mediaType: String = ""
	var releaseItems: [ ReleaseItem ] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		navItem.title = getNavTitle( mediaType )

		if let releaseItems = releaseItemCtrl.releaseItemsByType[ mediaType ] {
			self.releaseItems = releaseItems
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func getNavTitle( mediaType: String ) -> String {
		switch mediaType {
			case "Book": return "Books"
			case "Movie": return "Movies"
			case "TV": return "TV"
			case "Game": return "Games"
			case "Music": return "Music"
			default: return "Release Items"
		}
	}

	// MARK: - Table view data source

	override func tableView( tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
		return releaseItems.count
	}

	override func tableView( tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath ) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier( "releaseItem", forIndexPath: indexPath ) as! ReleaseItemTableViewCell

		cell.releaseItemNameLabel.text = releaseItems[ indexPath.row ].name
		cell.releaseItemDateLabel.text = releaseItemCtrl.formatDateToDisplayString( releaseItems[ indexPath.row ].releaseDate )
		cell.releaseItemConfirmedImage.hidden = !releaseItems[ indexPath.row ].releaseDateConfirmed

		return cell
	}

	// MARK: - Navigation

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showReleaseItemDetail" {
			if let destination = segue.destinationViewController as? ReleaseItemDetailViewController,
			indexPath = self.tableView.indexPathForSelectedRow,
			releaseItem = releaseItemCtrl.releaseItemsByType[ mediaType ] {
				destination.releaseItem = releaseItem[ indexPath.row ]
			}
		}
	}

}
