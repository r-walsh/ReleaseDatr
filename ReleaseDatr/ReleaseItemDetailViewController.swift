//
//  ReleaseItemDetailViewController.swift
//  ReleaseDatr
//
//  Created by Ryan Walsh on 7/25/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit

class ReleaseItemDetailViewController: UIViewController {

	let releaseItemCtrl = ReleaseItemController.sharedController
	var releaseItem: ReleaseItem?

	@IBOutlet weak var releaseItemNameAndMediaTypeLabel: UILabel!
	@IBOutlet weak var releaseDateLabel: UILabel!
	@IBOutlet weak var releaseDateConfirmedImage: UIImageView!
	@IBOutlet weak var navItem: UINavigationItem!
	@IBOutlet weak var watchButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()

		if let releaseItem = releaseItem {
			releaseItemNameAndMediaTypeLabel.text = releaseItem.name
			releaseDateLabel.text = releaseItemCtrl.formatDateToDisplayString( releaseItem.releaseDate )
			releaseDateConfirmedImage.hidden = !releaseItem.releaseDateConfirmed
			navItem.title = releaseItem.mediaType
			watchButton.setTitle( "Subscribe to \( releaseItem.name )", forState: .Normal )
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	override func prepareForSegue( segue: UIStoryboardSegue, sender: AnyObject? ) {
		if segue.identifier == "embeddedSourcesTableView" {
			if let releaseItem = self.releaseItem, destination = segue.destinationViewController as? SourcesTableViewController {
				destination.sources = releaseItem.releaseDateSources
			}
		}
	}

}
